//
//  SceneDelegate.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let workerTitles = ["Visual Insights", "Equipment Maintenance Advisor"]
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        UILabel.appearance().font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 0/255, green: 45/255, blue: 156/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)]
        
//        if UIDevice.current.model == "iPad" {
//            UINavigationBar.appearance().prefersLargeTitles = true
//        }
//
        
        UITabBar.appearance().barTintColor = UIColor(displayP3Red: 0/255, green: 45/255, blue: 156/255, alpha: 1.0)
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().unselectedItemTintColor = .white

//        UITabBar.appearance().layer.borderWidth = 5
//        UITabBar.appearance().layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        for (key, title) in workerTitles.enumerated() {
            if let tabBarController = window?.rootViewController as? UITabBarController {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "DashboardNavController")
                vc.tabBarItem = UITabBarItem(title: title, image: nil, tag: key+1)
                tabBarController.viewControllers?.append(vc)
//
            }
        }
        
        if let tabBarController = window?.rootViewController as? UITabBarController {
//            tabBarController.tabBar.barTintColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 10)!], for: .normal)
            
            for vc in tabBarController.viewControllers! {
                vc.tabBarItem.image = .strokedCheckmark
            }
            
        }
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

