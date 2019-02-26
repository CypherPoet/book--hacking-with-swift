//
//  AppDelegate.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationAuthorizationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
    let notificationPresentationOptions: UNNotificationPresentationOptions = [.alert, .sound, .badge]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        UNUserNotificationCenter.current().requestAuthorization(options: notificationAuthorizationOptions) {
            (granted: Bool, error: Error?) in
            if let error = error {
                print("Error while attempting to grant notification authorization:\n\(error.localizedDescription)")
            } else {
                UNUserNotificationCenter.current().delegate = self
                application.registerForRemoteNotifications()
            }
        }
        
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


extension AppDelegate: UNUserNotificationCenterDelegate {

    /**
     Show the notification, even when the app is currently running
     */
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler(notificationPresentationOptions)
    }
}

