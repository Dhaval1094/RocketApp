//
//  DetailViewController.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Variables
    public var rocketDetails: Rocket?
    public var launchDetails: Launches?
    
    //MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
    
    //MARK: - Methods
    
    func configureUI() {
        title = NavigationTitle.DetailViewTitle
        if let url = URL(string: launchDetails?.mission?.missionPatch ?? "") {
            imageView.setImageWith(url: url , placeholder: UIImage(named: "rocket_icon"), imageIndicator: .gray, completion: nil)
        }
        if let r = self.rocketDetails?.rocket, let name = r.name, let type = r.type, let desc = self.launchDetails?.mission?.name, let code = self.launchDetails?.site {
            self.textView.text = "\u{1F680} Name: \(name) \r\n\u{1F680} Type: \(type) \r\n\u{1F680} Code: \(code) \r\n\u{1F680} Desc: \(desc) "
        }
        imageView.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.imageView.transform = CGAffineTransform.identity
        })
    }
    
}
