//
//  HomeViewController.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import UIKit
import RxSwift
import Action
import EZProgressHUD

class HomeViewController: UIViewController, Alertable {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnLoadMore: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    private var vm: HomeVMType!
    private var disposeBag = DisposeBag()
    private var launchData: [Launches]?
    private var selectedObj: Launches?
    
    //MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vm = HomeVM()
        configureUI()
        bindVM()
    }
    
    //MARK: - Methods
    
    func configureUI() {
        collectionView.registerCell(HomeCollViewCell.self)
        btnLoadMore.isEnabled = false
        title = NavigationTitle.HomeViewTitle
        launchData = NetworkConnectionManager.shared.connected ? [Launches]() : StorageManager.unarchiveAllLaunches()
        collectionView.reloadData()
    }
    
    func bindVM() {
        
        btnLoadMore.rx.action = CocoaAction(workFactory: { [weak self] () -> Observable<Void> in
            //Cursor is for pagination
            //On passing cursor API will fetch the next page
            guard let strongSelf = self else { return .empty()}
            guard let cursor = strongSelf.vm.lastCursor else {
                return .empty()
            }
            let dto = FetchMoreLaunchesDTO(cursor: cursor)
            //API call for LoadMore
            strongSelf.vm.onLoadMoreData.execute(dto)
            return .empty()
        })
        
        //Subscribe launchData for observe any changes to that object
        vm.launchData
            .subscribe(onNext: handleRocketLaunchData())
            .disposed(by: disposeBag)
        
        //Subscribe rocketData for observe any changes to that object
        vm.rocketData
            .subscribe(onNext: handleRocketDetailsData())
            .disposed(by: disposeBag)
        
        //For check the state of result after completion of event
        vm.state.isCompleteByAction()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                if let type = type {
                    switch type {
                    case .fetchLauncheDetail:
                        //Do something on completion of fetch
                        break
                    case .fetchRocketDetail:
                        guard let rocket = StorageManager.unarchive(path: "rocket" + (self.selectedObj?.id ?? ""), type: "rocket") as? Rocket else {
                            return
                        }
                        let detailView = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
                        detailView.launchDetails = self.selectedObj
                        detailView.rocketDetails = rocket
                        self.navigationController?.pushViewController(detailView, animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        //For handling the error after completion of any event
        vm.error
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: handleError())
            .disposed(by: disposeBag)
        
        //Call LaunchData API
        vm.onGetLaunchData.execute()
    }
    
}

//MARK: - Handlers
private extension HomeViewController {
    func handleRocketLaunchData() -> (([Launches]?) -> Void)? {
        return { [weak self] launches in
            guard let strongSelf = self, let newLaunches = launches else { return }
            if strongSelf.launchData != nil {
                strongSelf.launchData!.append(contentsOf: newLaunches)
                for obj in strongSelf.launchData! {
                    StorageManager.archive(object: obj as NSObject, path: "launch" + (obj.id ?? ""))
                    strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    func handleRocketDetailsData() -> ((Rocket?) -> Void)? {
        return { [weak self] rocket in
            guard let self = self, let rocket = rocket else { return }
            let path = "rocket" + (self.selectedObj?.id ?? "")
            StorageManager.archive(object: rocket, path: path)
        }
    }
    func handleState() -> SingleResult<Bool> {
        return { isComplete in
            //Get the completion state of the API call
        }
    }
    
    func handleError() -> SingleResult<Error?> {
        return { [weak self] error in
            guard let self = self, let error = error else { return }
            self.showAlert(message: error.localizedDescription)
        }
    }
}

//MARK: - UICollection View Delegate/Datasource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launchData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeCollViewCell.self, for: indexPath)
        guard let obj = launchData?[indexPath.item] else {
            return cell
        }
        cell.configureWith(obj: obj)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width / 2.3, height: self.view.frame.size.height/3.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        btnLoadMore.isEnabled = indexPath.row == launchData!.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let obj = launchData?[indexPath.item], let launchId = obj.id else {
            return
        }
        if !NetworkConnectionManager.shared.connected {
            guard let rocket = StorageManager.unarchive(path: "rocket" + (obj.id ?? ""), type: "rocket") as? Rocket else {
                //Still rocket detail not stored
                //Redirect in details for only stored objects
                return
            }
            let detailView = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            detailView.launchDetails = obj
            detailView.rocketDetails = rocket
            self.navigationController?.pushViewController(detailView, animated: true)
        } else {
            self.selectedObj = obj
            let dto = FetchLaunchDetailsDTO.init(launchId: launchId)
            vm.onLaunchDetails.execute(dto)
        }
    }
    
}
