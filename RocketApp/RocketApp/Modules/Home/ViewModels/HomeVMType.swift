//
//  HomeVMType.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import Action
import RxCocoa
import RxSwift
import RxSwiftExt

protocol HomeVMType: ActivityStateMachineType {
    var onGetLaunchData: Action<Void, Void> { get }
    var onLoadMoreData: Action<FetchMoreLaunchesDTO, Void> { get }
    var onLaunchDetails: Action<FetchLaunchDetailsDTO, Void> { get }
    var launchData: Observable<[Launches]?> { get }
    var rocketData: Observable<Rocket?> { get }
    var lastCursor: String? { get }
}

final class HomeVM: HomeVMType {
    
    private var disposeBag = DisposeBag()
    
    private var stateRelay = BehaviorRelay<ActivityState>(value: .idle)
    private var errorRelay = BehaviorRelay<Error?>(value: nil)
    private var launchRelay = BehaviorRelay<[Launches]?>(value: nil)
    private var rocketRelay = BehaviorRelay<Rocket?>(value: nil)
    var state: Observable<ActivityState> { return stateRelay.asObservable() }
    var error: Observable<Error?> { return errorRelay.asObservable() }
    
    private let homeService: HomeServiceType = HomeService()

    var launchData: Observable<[Launches]?> { return launchRelay.asObservable() }
    var rocketData: Observable<Rocket?> { return rocketRelay.asObservable() }
    var lastCursor: String?
    
    var onGetLaunchData: Action<Void, Void> {
        return Action<Void, Void> { _ in
            self.requestGetLaunchData()
            return .empty()
        }
    }
    
    var onLoadMoreData: Action<FetchMoreLaunchesDTO, Void> {
        return Action { dto in
            self.requestLoadMoreData(dto: dto)
            return .empty()
        }
    }
    
    var onLaunchDetails: Action<FetchLaunchDetailsDTO, Void> {
        return Action { dto in
            self.requestLaunchDetails(dto: dto)
            return .empty()
        }
    }
    
}

// MARK: - Service requests
private extension HomeVM {
    
    func requestLoadMoreData(dto: FetchMoreLaunchesDTO) {
        let request = homeService.requestLoadMoreData(dto: dto)
        handleLaunchListResponse(commonRequest: request)
    }
    
    func requestGetLaunchData() {
        let request = homeService.requestGetLaunchData()
        handleLaunchListResponse(commonRequest: request)
    }
    
    func requestLaunchDetails(dto: FetchLaunchDetailsDTO) {
        let request = homeService.requestGetLaunchDetails(dto: dto)
        handleLaunchDetailsResponse(request: request)
    }
    
    func handleLaunchListResponse(commonRequest: Observable<LaunchConnection>) {
        stateRelay.accept(.loading)
        Indicator.shared.show()
        let request = commonRequest.materialize().share(replay: 1)
        request.elements().do(onNext: { (result) in
            Indicator.shared.hide()
            self.lastCursor = result.cursor
            self.launchRelay.accept(result.launches)
        }).mapTo(ActivityState.complete(item: .fetchLauncheDetail))
        .bind(to: stateRelay)
        .disposed(by: self.disposeBag)
        
        request
            .errors()
            .do(onNext: { [weak self] error in
                Indicator.shared.hide()
                guard let strongSelf = self else { return }
                print(error.localizedDescription)
                strongSelf.stateRelay.accept(.idle)
            })
            .bind(to: errorRelay)
            .disposed(by: self.disposeBag)
    }
    
    func handleLaunchDetailsResponse(request: Observable<Rocket>) {
        stateRelay.accept(.loading)
        Indicator.shared.show()
        let request = request.materialize().share(replay: 1)
        request.elements().do(onNext: { (rocket) in
            Indicator.shared.hide()
            self.rocketRelay.accept(rocket)
        }).mapTo(ActivityState.complete(item: .fetchRocketDetail))
        .bind(to: stateRelay)
        .disposed(by: self.disposeBag)
        
        request
            .errors()
            .do(onNext: { [weak self] error in
                Indicator.shared.hide()
                guard let strongSelf = self else { return }
                print(error.localizedDescription)
                strongSelf.stateRelay.accept(.idle)
            })
            .bind(to: errorRelay)
            .disposed(by: self.disposeBag)
    }
    
}
