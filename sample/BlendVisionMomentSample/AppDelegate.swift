//
//  AppDelegate.swift
//  BlendVisionSample
//
//  Created by chantil on 2021/2/24.
//  Copyright © 2021 KKStream Limited. All rights reserved.
//

import UIKit
import BlendVisionMoment

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // [Optional] Uncomment next line to opt-in GoogleCast
//        Configuration.setupGoogleCast(applicationID: googleCastApplicationId)

        if #available(iOS 13.0, *) {} else {
            let viewControllers = [UINavigationController(rootViewController: DemoViewController(),
                                                          title: "BlendVision Moment"),
                                   UINavigationController(rootViewController: SettingsViewController(),
                                                          title: "Settings")]
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers(viewControllers, animated: false)

            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

