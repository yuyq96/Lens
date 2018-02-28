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
        self.window?.backgroundColor = .white
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let productRootViewContoller = BrowsePagerTabStripViewController()
        productRootViewContoller.navigationItem.title = Context.Tab.equipment
        productRootViewContoller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: productRootViewContoller, action: #selector(productRootViewContoller.setProdutFilter))
        let productViewController = NavigationController(rootViewController: productRootViewContoller)
        
        let newsRootViewContoller = BrowsePagerTabStripViewController()
        newsRootViewContoller.navigationItem.title = Context.Tab.news
        let newsViewController = NavigationController(rootViewController: newsRootViewContoller)
        
        let personalRootViewController = PersonalViewController(style: .grouped)
        personalRootViewController.navigationItem.title = Context.Tab.personal
        let personalViewController = NavigationController(rootViewController: personalRootViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = Color.tint
        tabBarController.tabBar.isTranslucent = false
        
        productViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.equipment), selectedImage: UIImage(named: Context.Tab.equipment + "_S"))
        newsViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.news), selectedImage: UIImage(named: Context.Tab.news + "_S"))
        personalViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: Context.Tab.personal), selectedImage: UIImage(named: Context.Tab.personal + "_S"))
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

