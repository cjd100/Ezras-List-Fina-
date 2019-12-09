//
//  AppDelegate.swift
//  ezraslist_appdevfinal
//
//  Created by Sophia Wang on 12/8/19.
//  Copyright © 2019 Sophia Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
                  window?.rootViewController = UINavigationController(rootViewController: ViewController())
                  window?.makeKeyAndVisible()
        return true

    }

}

