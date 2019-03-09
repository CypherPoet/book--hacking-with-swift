//
//  ViewController.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController {
    // MARK: - Instance Properties
    
    let coreDataFileName = "GithubCommits"
    lazy var dataContainer = NSPersistentContainer(name: coreDataFileName)
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dataContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Error while attempting to load persistent data store:\n\(error.localizedDescription)")
            }
        }
    }

    
    // MARK: - Core Methods
    
    func saveData() {
        guard dataContainer.viewContext.hasChanges else { return }
        
        do {
            try dataContainer.viewContext.save()
        } catch {
            print("Error while saving persistent data store: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: - Private functions
    
//    private func makeDataContainer() -> NSPersistentContainer {
//        let container = NSPersistentContainer(name: coreDataFileName)
//
//        return container
//    }
}

