//
//  HomeViewController.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }
  
    //MARK: - Methods
    func configureUI() {
        title = NavigationTitle.HomeViewTitle
    }

}
