//
//  MyGenresTableViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CloudKit


class MyGenresTableViewController: UITableViewController {
    /// Tracks the list of genres the user considers themselves an expert on
    var userGenres: [String] = []
    lazy var allGenres = Genre.allCases.map { $0.rawValue }
    
    let cellReuseIdentifier = "Cell"

    lazy var userDefaults = UserDefaults.standard
    lazy var publicCloudDatabase = CKContainer.default().publicCloudDatabase
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGenres()
        setupNavbar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGenres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let genre = allGenres[indexPath.row]
        
        cell.textLabel?.text = genre
        cell.accessoryType = userGenres.contains(genre) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let genre = allGenres[indexPath.row]
        
        if let index = userGenres.firstIndex(of: genre) {
            userGenres.remove(at: index)
            cell.accessoryType = .none
        } else {
            userGenres.append(genre)
            cell.accessoryType = .checkmark
        }
        
        // make sure our selected cell only highlights briefly
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - Event handling
    
    @objc func saveTapped() {
        saveGenres()
        subscribeToNotifications()
    }

    
    // MARK: - Helper functions
    
    func loadGenres() {
        if let savedGenres = userDefaults.object(forKey: UserDefaultsKey.userGenres) as? [String] {
            userGenres = savedGenres
        }
    }
    
    func setupNavbar() {
        title = "Ask for my expertise on..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
    
    func saveGenres() {
        userDefaults.set(userGenres, forKey: UserDefaultsKey.userGenres)
    }
    
    
    func subscribeToNotifications() {
        publicCloudDatabase.fetchAllSubscriptions { [unowned self] (subscriptions: [CKSubscription]?, error: Error?) in
            if let error = error {
                self.displayBasicAlert(
                    title: "Network error",
                    message: """
                        An error occured while attempting to access your current notification \
                        subscriptions:\n\(error.localizedDescription)\nPlease try again later.
                        """
                )
            } else {
                guard let subscriptions = subscriptions else { return }
                
                subscriptions.forEach({ subscription in
                    self.publicCloudDatabase.delete(withSubscriptionID: subscription.subscriptionID) {
                        (_: String?, error: Error?) in
                        // 📝 TODO: Handle this
                        if let error = error {
                            self.displayBasicAlert(
                                title: "Save error",
                                message: """
                                    An error occured while attempting to save your current notification \
                                    subscriptions:\n\(error.localizedDescription)\nPlease try again later.
                                    """
                            )
                        }
                    }
                })
                
                self.makeSubscriptions()
            }
        }
    }
    
    func makeSubscriptions() {
        for genre in userGenres {
            let notificationInfo = CKSubscription.NotificationInfo()
            
            notificationInfo.alertBody = "There's a new sound bite for the \"\(genre)\" genre"
            notificationInfo.soundName = "default"
            
            let predicate = NSPredicate(format: "genre = %@", genre)
            let subscription = CKQuerySubscription(
                recordType: AppCKRecordType.soundBites,
                predicate: predicate,
                options: .firesOnRecordCreation
            )
            
            subscription.notificationInfo = notificationInfo
            
            publicCloudDatabase.save(subscription) { [unowned self] (_, error: Error?) in
                if let error = error {
                    self.displayBasicAlert(
                        title: "Save error",
                        message: """
                            An error occured while attempting to save your subscription \
                            to the "\(genre)" genre:
                            \
                            \(error.localizedDescription)
                            \
                            Please try again later.
                            """
                    )
                }
            }
        }
    }
}
