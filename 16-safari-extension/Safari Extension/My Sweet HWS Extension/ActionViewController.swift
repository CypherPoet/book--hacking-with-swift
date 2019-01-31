//
//  ActionViewController.swift
//  My Sweet HWS Extension
//
//  Created by Brian Sipple on 1/30/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet weak var scriptTextView: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    let keyboardNotificationNames = [UIResponder.keyboardWillHideNotification, UIResponder.keyboardWillChangeFrameNotification]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationObservers()
        setupUI()
        
        // `inputItems` should be an array of data that the parent app is sending to our extension to use
        guard let inputItem = extensionContext!.inputItems.first as? NSExtensionItem else { return }
        
        // Our input item contains an array of attachments, which are given to us wrapped up as an `NSItemProvider`
        guard let itemProvider = inputItem.attachments?.first else { return }
        
        let typeIdentifier = kUTTypePropertyList as String
        
        // After finding the provider, we need to ask it to actually provide us with its item
        itemProvider.loadItem(
            forTypeIdentifier: typeIdentifier,
            options: nil,
            completionHandler: { [unowned self] (dict, error) in
                let itemDictionary = dict as! NSDictionary
                let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                
                self.pageURL = javaScriptValues["URL"] as! String
                self.pageTitle = javaScriptValues["title"] as! String
                
                DispatchQueue.main.async {
                    self.title = self.pageTitle
                }
            }
        )
    }
    
    
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(done)
        )
    }
    
    
    func setupNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        
        for notificationName in keyboardNotificationNames {
            notificationCenter.addObserver(
                self,
                selector: #selector(adjustForKeyboardMovements),
                name: notificationName,
                object: nil
            )
        }
    }
    
    @objc func adjustForKeyboardMovements(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keybardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            // 🔑 workaround for hardware keyboards being connected
            scriptTextView.contentInset = UIEdgeInsets.zero
        } else {
            scriptTextView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keybardViewEndFrame.height,
                right: keybardViewEndFrame.width
            )
        }
        
        scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
        
        // scroll to the current positoin of the text entry cursor if it's off screen
        scriptTextView.scrollRangeToVisible(scriptTextView.selectedRange)
    }
    
    
    func makeExtensionItemOnCompletion() -> NSExtensionItem {
        let argument: NSDictionary = ["customJavaScript": scriptTextView.text]
        
        // 🔑 This is what will be sent as the argument to our script's `finalize` function
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        
        let customJSProvider = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)

        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [customJSProvider]
        
        return extensionItem
    }
    

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(
            returningItems: [makeExtensionItemOnCompletion()],
            completionHandler: nil
        )
    }
    

}
