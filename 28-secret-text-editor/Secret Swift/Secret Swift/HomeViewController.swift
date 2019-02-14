//
//  ViewController.swift
//  Secret Swift
//
//  Created by Brian Sipple on 2/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    lazy var notificationCenter = NotificationCenter.default
    
    lazy var keyboardMovementNotifications = [
        UIResponder.keyboardWillHideNotification,
        UIResponder.keyboardWillChangeFrameNotification,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addNotificationObservers()
    }

    
    func addNotificationObservers() {
        for notification in keyboardMovementNotifications {
            notificationCenter.addObserver(self, selector: #selector(handleKeyboardMovement), name: notification, object: nil)
        }
    }
    

    @objc func handleKeyboardMovement(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        textView.scrollRangeToVisible(textView.selectedRange)
    }
}

