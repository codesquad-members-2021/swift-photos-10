//
//  AppDelegate.swift
//  swift-photos-10
//
//  Created by user on 2021/03/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var doodleViewController : DoodleViewController!
    var navigationController : UINavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        doodleViewController = DoodleViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController = UINavigationController(rootViewController: doodleViewController)
        
        return true
    }

}

