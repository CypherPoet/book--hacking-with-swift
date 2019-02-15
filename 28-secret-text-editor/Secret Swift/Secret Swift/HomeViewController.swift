//
//  ViewController.swift
//  Secret Swift
//
//  Created by Brian Sipple on 2/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import KeychainAccess
import LocalAuthentication

enum Title: String {
    case nondescript = "✌️ Swift Notes"
    case unlocked = "🔓 Secret Unlocked"
}

enum ViewMode: String {
    case secretHidden
    case secretShowing
}

class HomeViewController: UIViewController {
    @IBOutlet weak var secretTextView: UITextView!
    
    lazy var notificationCenter = NotificationCenter.default
    
    lazy var keyboardMovementNotifications = [
        UIResponder.keyboardWillHideNotification,
        UIResponder.keyboardWillChangeFrameNotification,
    ]
    
    lazy var keychain = Keychain(service: "io.sipple.Secret-Swift")
    lazy var authContext = LAContext()
    
    var currentViewMode = ViewMode.secretHidden {
        didSet {
            viewModeChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addNotificationObservers()
    }
    
    func addNotificationObservers() {
        for notification in keyboardMovementNotifications {
            notificationCenter.addObserver(self, selector: #selector(handleKeyboardMovement), name: notification, object: nil)
        }
        
        notificationCenter.addObserver(
            self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil
        )
    }
    
    func unlockSecretMessage() {
        currentViewMode = .secretShowing
        
        if let secretText = try? keychain.getString("secretText") {
            secretTextView.text = secretText
        }
    }
    
    @objc func saveSecretMessage() {
        guard currentViewMode == .secretShowing else { return }
        
        keychain[string: "secretText"] = secretTextView.text
        
        // have the text view give up focus so the keyboard will hide
        secretTextView.resignFirstResponder()
        currentViewMode = .secretHidden
    }

    
    @objc func handleKeyboardMovement(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretTextView.contentInset = UIEdgeInsets.zero
        } else {
            secretTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        secretTextView.scrollIndicatorInsets = secretTextView.contentInset
        secretTextView.scrollRangeToVisible(secretTextView.selectedRange)
    }
    
    
    func viewModeChanged() {
        switch currentViewMode {
        case .secretHidden:
            title = Title.nondescript.rawValue
            secretTextView.isHidden = true
        case .secretShowing:
            title = Title.unlocked.rawValue
            secretTextView.isHidden = false
        }
    }
    
    
    func authFailed() {
        let alertController = UIAlertController(
            title: "Authentication Failed",
            message: "You could not be verified. Please try again",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func authenticateTapped(_ sender: Any) {
        var error: NSError?
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            authContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason,
                reply: { (success: Bool, error: Error?) in
                    DispatchQueue.main.async { [unowned self] in
                        if success {
                            self.unlockSecretMessage()
                        } else {
                            self.authFailed()
                        }
                        
                    }
                }
            )
            
        } else {
            // 📝 TODO: Handle case where no biometrics are supported
            print("No Bio")
        }
    }
}

