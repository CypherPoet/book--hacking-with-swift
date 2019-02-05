//
//  NoteDetailViewController.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    var note: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupNavbar()
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
