 //
//  AppDelegate.swift
//  Productivity App
//
//  Created by Rishi Pochiraju on 3/19/16.
//  Copyright © 2016 Rishi P. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func storeData() {
        
        var storeItemList = [NSString]()
        var isStruckArr = [Bool]()
        var isScheduledArr = [Bool]()
        
        if (toDoItems.count > 0){
            for i in 0 ..< toDoItems.count{
                let saveString: String = toDoItems[i].text
                storeItemList.append(saveString as NSString)
                isStruckArr.append(toDoItems[i].isStruck)
                isScheduledArr.append(toDoItems[i].isScheduled)
                
            }
            
            
            defaults.set(isScheduledArr, forKey: "scheduled")
            defaults.set(isStruckArr, forKey: "struck")
            defaults.set(storeItemList, forKey: "myItems")
        }
        
        let countTasks:Int = toDoItems.count
        defaults.set(countTasks, forKey: "numberOfTasks")
        defaults.synchronize()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Use Firebase library to configure APIs
        FIRApp.configure()
        // Override point for customization after application launch.        
        UITabBar.appearance().tintColor = UIColor(red: 123/255.0, green: 182/255.0, blue: 232/255.0, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
        

        
        self.window!.tintColor = UIColor(red: 28.0/255.0, green: 66.0/255.0, blue: 112.0/255.0, alpha: 1.0)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        storeData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //here - copy data from toDoItems into the stored array
        storeData()
    }


}

