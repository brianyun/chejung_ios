//
//  AppDelegate.swift
//  chejung
//
//  Created by 윤희상 on 2017. 8. 21..
//  Copyright © 2017년 Clutch Studio. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //UIBuilder 쓰기 위한 선언.
    let ub: UIBuilder = UIBuilder()
    var window: UIWindow?

    //공유를 위한 변수 선언.
    var dateShared : String = String()
    var mealShared : Int = Int()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 0.3) //LaunchScreen 보여주기 위해 인위적으로 0.3초 멈춤.
        
        
        Fabric.with([Crashlytics.self])
        
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true
        }
        gai.tracker(withTrackingId: "UA-110222885-1")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        // gai.logger.logLevel = .verbose;
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
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

