//
//  AppDelegate.swift
//  Grassroots
//
//  Created by Daniel Bennett on 8/15/16.
//  Copyright © 2016 Daniel Bennett. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
          [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        let material_green = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)
      
      
      
      if UserDefaults.standard.bool(forKey: "launched") == false {
        //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SignInController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
      }
      
        UINavigationBar.appearance().barTintColor = material_green
      
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 24)!]
      
      
        //application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil))
        //UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
  
  
    //EFFECTS: updates election data and notifies user of new elections
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        if let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers! as? [UIViewController] {
            for viewController in viewControllers {
//                if viewController is HomeViewController {
//                    
//                    //homeViewController.tbc.model.getElections(homeViewController.electionCompletionHandler)
//                    
//                    
//                
//                }
            }
        }
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

