//
//  ViewController.swift
//  Multibrowser
//
//  Created by Brian Sipple on 2/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit

let defaultTitle = "Web View Wonderland"

class HomeViewController: UIViewController {
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var deleteWebViewButton: UIBarButtonItem!
    
    lazy var defaultURL = URL(string: "https://developer.apple.com/develop/")!
    
    weak var activeWebView: WKWebView! {
        didSet {
            activeWebViewChanged()
            updateAddressBar(for: activeWebView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addressBar.delegate = self
        setupDefaultUI()
    }
    
    
    func activeWebViewChanged() {
        if activeWebView == nil {
            setupDefaultUI()
        } else {
            title = activeWebView.title
            deleteWebViewButton.isEnabled = true
            
            for view in stackView.arrangedSubviews {
                view.layer.borderWidth = 0
            }
            
            activeWebView.layer.borderWidth = 3
        }
    }
    
    
    func setupDefaultUI() {
        deleteWebViewButton.isEnabled = false
        title = defaultTitle
    }
    
    func updateAddressBar(for webView: WKWebView) {
        addressBar.text = webView.url?.absoluteString ?? ""
    }
    
    func replaceActiveWebView(afterDeletingFromIndex previousIndex: Int) {
        if stackView.arrangedSubviews.isEmpty {
            activeWebView = nil
        } else {
            // if that was the last web view in the stack, move the index back one
            let targetIndex = min(previousIndex, stackView.arrangedSubviews.count - 1)

            activeWebView = stackView.arrangedSubviews[targetIndex] as? WKWebView ?? nil
        }
    }
    
    
    @IBAction func deleteWebView(_ sender: Any) {
        guard activeWebView != nil else { return }
        
        if let index = stackView.arrangedSubviews.firstIndex(of: activeWebView) {
            stackView.removeArrangedSubview(activeWebView)
            activeWebView.removeFromSuperview()
            
            replaceActiveWebView(afterDeletingFromIndex: index)
        }
    }
    
    /**
     - When we have a regular horizontal size class, we'll use horizontal stacking
     - When we have a compact horizontal size class, we'll use vertical stacking
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let horizontalSizeClasss = previousTraitCollection?.horizontalSizeClass else { return }
        
        switch horizontalSizeClasss {
        case .regular, .unspecified:
            stackView.axis = .horizontal
        case .compact:
            stackView.axis = .vertical
        }
    }
    
    
    @IBAction func addWebView(_ sender: Any) {
        let webView = WKWebView()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        
        webView.navigationDelegate = self
        webView.layer.borderColor = UIColor.blue.cgColor
        
        gestureRecognizer.delegate = self
        webView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(webView)
        webView.load(URLRequest(url: defaultURL))

        activeWebView = webView
    }
}


extension HomeViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateAddressBar(for: webView)
    }
}



extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if activeWebView != nil, let address = addressBar.text {
            if let url = URL(string: address) {
                activeWebView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
}


extension HomeViewController: UIGestureRecognizerDelegate {
    /**
     Tell iOS we want our own gesture recognizer to trigger alongside the recognizers built in to each WKWebView
     */
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
    @objc func webViewTapped(sender: UITapGestureRecognizer) {
        if let webView = sender.view as? WKWebView {
            activeWebView = webView
        }
    }
}
