//
//  AppDelegate.swift
//  Lens
//
//  Created by Archie Yu on 2018/2/23.
//  Copyright © 2018年 Archie Yu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        user.syncSettings(completion: nil)
        
        self.window?.backgroundColor = .white
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let productRootViewContoller = BrowsePagerTabStripViewController()
        productRootViewContoller.tab = .equipment
        let productViewController = NavigationController(rootViewController: productRootViewContoller)
        
        let newsRootViewContoller = BrowseViewController(style: .grouped)
        newsRootViewContoller.tab = .news
        let newsViewController = NavigationController(rootViewController: newsRootViewContoller)
        
        let personalRootViewController = PersonalViewController(style: .grouped)
        personalRootViewController.navigationItem.title = NSLocalizedString("Personal", comment: "Personal")
        let personalViewController = NavigationController(rootViewController: personalRootViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = Color.tint
        tabBarController.tabBar.isTranslucent = false
        
        productViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.equipment.rawValue), selectedImage: UIImage(named: Context.Tab.equipment.rawValue + "_S"))
        newsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.news.rawValue), selectedImage: UIImage(named: Context.Tab.news.rawValue + "_S"))
        personalViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.personal.rawValue), selectedImage: UIImage(named: Context.Tab.personal.rawValue + "_S"))
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        productViewController.tabBarItem.imageInsets = insets
        newsViewController.tabBarItem.imageInsets = insets
        personalViewController.tabBarItem.imageInsets = insets
        tabBarController.viewControllers = [productViewController, newsViewController, personalViewController]
        tabBarController.selectedIndex = 0
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain categorys of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

