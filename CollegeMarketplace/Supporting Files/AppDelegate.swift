//
//  AppDelegate.swift
//  CollegeMarketplace
//
//  Created by Kota Ueshima on 4/4/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
//        Auth.auth().addStateDidChangeListener { auth, user in
//            let isLoggedIn = user != nil
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let window = UIWindow(frame: UIScreen.main.bounds)
//
//            if isLoggedIn{
//                let tabBar = storyboard.instantiateViewController(withIdentifier: "TabBar")
//
//                window.rootViewController = tabBar
//                window.makeKeyAndVisible()
//            } else {
//                let loginNav = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")
//
//                window.rootViewController = loginNav
//                window.makeKeyAndVisible()            }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

