//
//  HomeViewController.swift
//  Local Notifications
//
//  Created by Brian Sipple on 2/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
    }
    
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Register",
            style: .plain,
            target: self,
            action: #selector(registerLocalNotifications)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Schedule",
            style: .plain,
            target: self,
            action: #selector(scheduleLocalNotifications)
        )
    }
    
    
    @objc func registerLocalNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (authWasGranted: Bool, _: Error?) -> Void in
                print(authWasGranted ? "🎉" : "😢")
            }
        )
    }
    
    
    @objc func scheduleLocalNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removeAllPendingNotificationRequests()
        
        let calendarRequest = makeCalendarNotificationRequest()
        let intervalRequest = makeIntervalNotificationRequest()
        
        notificationCenter.add(calendarRequest)
        notificationCenter.add(intervalRequest)
    }
    
    
    func makeCalendarNotificationRequest() -> UNNotificationRequest {
        var dateComponents = DateComponents()
        
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let content = UNMutableNotificationContent()
        
        content.title = "🤯 Woah!"
        content.body = "The Earth has spun 0.00417 degrees on its axis since its day began in your time zone."
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Universe Updates"
        content.userInfo = ["planet": "Earth"]
        
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
    
    func makeIntervalNotificationRequest() -> UNNotificationRequest {
        let timeInterval = 60.0 * 10.0 // 10 minutes
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        let content = UNMutableNotificationContent()
        
        content.title = "Another one"
        content.body = "Another block has been mined on the Bitcoin blockchain"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "Sound Money"
        content.userInfo = ["miningReward": 12.5]
        
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
}

