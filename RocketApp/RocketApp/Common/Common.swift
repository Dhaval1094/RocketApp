//
//  Common.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import UIKit

//MARK: - General Constant
let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - API Components
struct API {
    static let baseURL = "https://apollo-fullstack-tutorial.herokuapp.com/"
}

//MARK: - CollectionViewCell Identifiers
struct CollCellIdentifier {
    static let PhotoList = "HomeCollectionCell"
}

//MARK: - Navigation Titles
struct NavigationTitle {
    static let HomeViewTitle = "Rocket list"
    static let DetailViewTitle = "Rocket details"
}

//MARK: - Set Notification Observers
extension Notification.Name {
    static let networkStatusChange = Notification.Name("__networkStatusChangeNotification")
}
