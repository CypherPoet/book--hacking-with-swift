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
    var userGenres: [Genre] = []
    
    let cellReuseIdentifier = "Cell"
    lazy var userDefaults = UserDefaults.standard
    
    
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
        return Genre.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let genre = Genre.allCases[indexPath.row]
        
        cell.textLabel?.text = genre.rawValue
        cell.accessoryType = userGenres.contains(genre) ? .checkmark : .none
//        cell.accessoryType = .checkmark
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let genre = Genre.allCases[indexPath.row]
        
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
        
    }

    
    // MARK: - Helper functions
    
    func loadGenres() {
        if let savedGenres = userDefaults.object(forKey: UserDefaultsKey.userGenres) as? [Genre] {
            userGenres = savedGenres
        }
    }
    
    func setupNavbar() {
        title = "Ask for my expertise on..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
    }
}
