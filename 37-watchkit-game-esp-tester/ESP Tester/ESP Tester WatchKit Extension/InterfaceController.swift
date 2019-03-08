//
//  InterfaceController.swift
//  ESP Tester WatchKit Extension
//
//  Created by Brian Sipple on 3/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {
    @IBOutlet var welcomeText: WKInterfaceLabel!
    @IBOutlet var readyButton: WKInterfaceButton!
    
    lazy var watchConnectivitySession: WCSession? = {
        guard WCSession.isSupported() else { return nil }
        
        let session = WCSession.default
        session.delegate = self
        
        return session
    }()
    
    
    // MARK: - Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        watchConnectivitySession?.activate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // MARK: - Event handling
    
    @IBAction func readyButtonTapped() {
        welcomeText.setHidden(true)
        readyButton.setHidden(true)
    }
}


// MARK: - WCSessionDelegate

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO:
    }
    
    /**
     Whenever the watch recieves a message from the phone, it will tap the wearer's wrist
     */
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        WKInterfaceDevice().play(.click)
    }
}
