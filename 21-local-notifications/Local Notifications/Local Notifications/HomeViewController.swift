//
//  HomeViewController.swift
//  Local Notifications
//
//  Created by Brian Sipple on 2/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import UserNotifications

enum NotificationCategory: String {
    case soundMoney = "Sound Money"
    case universeUpdates = "Universe Updates"
}

class HomeViewController: UIViewController {
    var notificationCenter: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
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
        notificationCenter.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (authWasGranted: Bool, _: Error?) -> Void in
                print(authWasGranted ? "🎉" : "😢")
            }
        )
    }
    
    
    @objc func scheduleLocalNotifications() {
        registerCategories()
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
        content.categoryIdentifier = NotificationCategory.universeUpdates.rawValue
        content.userInfo = ["prediction": "This is likely to happen again soon."]
        
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
    
    func makeIntervalNotificationRequest() -> UNNotificationRequest {
        let timeInterval = 60.0 * 10.0 // 10 minutes
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        let content = UNMutableNotificationContent()
        
        content.title = "Another one"
        content.body = "Another block has been mined on the Bitcoin blockchain"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = NotificationCategory.soundMoney.rawValue
        content.userInfo = ["miningReward": 12.5]
        
        return UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    }
    
    func registerCategories() {
        notificationCenter.delegate = self
        
        
        let actions = [
            UNNotificationAction(identifier: "Show BTC Details", title: "Tell me more...", options: .foreground)
        ]
        
        let categories = [
            UNNotificationCategory(
                identifier: NotificationCategory.soundMoney.rawValue,
                actions: actions,
                intentIdentifiers: []
            )
        ]
        
        notificationCenter.setNotificationCategories(Set(categories))
    }
    
    func promptOnNotificationResponse(message: String) {
        let alertController = UIAlertController(title: "More Details", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "👌 OK", style: .default))
        
        self.present(alertController, animated: true)
    }
}


extension HomeViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let category = NotificationCategory(rawValue: response.notification.request.content.categoryIdentifier) {
            let userInfo = response.notification.request.content.userInfo

            var message: String
            
            switch category {
            case .soundMoney:
                message = "A mining reward of \(userInfo["miningReward"] as! Double) BTC was just awarded."
            case .universeUpdates:
                message = userInfo["prediction"] as! String
            }
            
            promptOnNotificationResponse(message: message)
        }
        
        completionHandler()
    }
}

