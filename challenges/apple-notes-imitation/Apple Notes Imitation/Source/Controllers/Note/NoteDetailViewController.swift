//
//  NoteDetailViewController.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    
    var note: Note!
    let keyboardNotificationNames = [UIResponder.keyboardWillHideNotification, UIResponder.keyboardWillChangeFrameNotification]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavbar()
        setupNotificationObservers()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareNote)
        )
    }
    
    func setupNotificationObservers() {
        let notificationCenter = NotificationCenter.default
        
        for notificationName in keyboardNotificationNames {
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardMovements), name: notificationName, object: nil)
        }
    }
    
    
    @objc func adjustForKeyboardMovements(notification: NSNotification) {
        // TODO: Figure out why this ends up sliding the text out of view to the side:
        
//        guard let userInfo = notification.userInfo else { return }
//
//        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keybardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            // 🔑 workaround for hardware keyboards being connected
//            noteTextView.contentInset = UIEdgeInsets.zero
//        } else {
//            noteTextView.contentInset = UIEdgeInsets(
//                top: 0,
//                left: 0,
//                bottom: keybardViewEndFrame.height,
//                right: keybardViewEndFrame.width
//            )
//        }
//
//        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
//
//        // scroll to the current positoin of the text entry cursor if it's off screen
//        noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
    }
    
    
    @objc func shareNote() {
        let activityController = UIActivityViewController(activityItems: [note], applicationActivities: [])
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }
    
    
    func saveNote() {
        // TODO: I haven't looked in to Core Data yet, but this is where I feel
        // like we really need to be leveraging a robust data layer that can
        // operate on "records"
    }
    
    @IBAction func noteDeleted(_ sender: Any) {
        // TODO: I haven't looked in to Core Data yet, but this is where I feel
        // like we really need to be leveraging a robust data layer that can
        // operate on "records"
    }
}
