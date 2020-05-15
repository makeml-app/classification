//
//  AppDelegate.swift
//  Classification
//
//  Created by artyom korotkov on 5/12/20.
//  Copyright © 2020 artyom korotkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: ChooseRecognitionTypeViewController())
        
        return true
    }


}

