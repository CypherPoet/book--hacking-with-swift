//
//  ViewController.swift
//  Easy Browser
//
//  Created by Brian Sipple on 1/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlsToChoose = [URL]()
    
    let siteNames = [
        "hackingwithswift.com",
        "google.com",
        "yalls.org",
        "developer.apple.com/develop"
    ]
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.allowsBackForwardNavigationGestures = true
        
        setupNavigationBar()
    }
    
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "🌐",
            style: .plain,
            target: self,
            action: #selector(openSitePicker)
        )
    }
    
    
    @objc func openSitePicker() {
        let alertController = UIAlertController(
            title: "Surf the Web!",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for siteName in siteNames {
            alertController.addAction(UIAlertAction(title: siteName, style: .default, handler: openPage))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alertController, animated: true)
    }
    
    
    func openPage(action: UIAlertAction) {
        let pageURL = URL(string: "https://\(action.title!)")!
        
        webView.load(URLRequest(url: pageURL))
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

