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
    
    let cellReuseIdentifier = "Commit Cell"
    var dataContainer: NSPersistentContainer!
    var commits: [Commit] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard dataContainer != nil else {
            fatalError("HomeViewController needs a persistent data container")
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fetchCommits()
        }
        
        loadSavedData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let commit = commits[indexPath.row]
        
        cell.textLabel?.text = commit.message
        cell.detailTextLabel?.text = commit.date.description
        
        return cell
    }
    
    
    // MARK: - Core Methods
    
    func fetchCommits() {
        if let commitsURL = URL(string: "\(GithubAPI.commits)?per_page=100") {
            do {
                let data = try Data(contentsOf: commitsURL)
                parseCommits(fromJSON: data)
            } catch {
                showError(title: "Error fetching data from Github API", message: error.localizedDescription)
            }
        } else {
            fatalError("Error constructing URL to GitHub API")
        }
    }
    
    
    func parseCommits(fromJSON json: Data) {
        guard let mangedObjectContextKey = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retreive managedObjectContext coding key")
        }
        
        let managedObjectContext = dataContainer.viewContext
        let decoder = JSONDecoder()
        
        decoder.userInfo[mangedObjectContextKey] = managedObjectContext
        
        do {
            let commits = try decoder.decode([Commit].self, from: json)
            print("Parsed \(commits.count) new commits from the API")
            
            DispatchQueue.main.async { [weak self] in
                self?.saveData()
                self?.loadSavedData()
            }
        } catch {
            showError(title: "Error while parsing `Commit` json data", message: error.localizedDescription)
        }
    }
    
    
    func loadSavedData() {
        let fetchRequest = Commit.createFetchRequest()
        let sort1 = NSSortDescriptor(key: "date", ascending: false)
        let sort2 = NSSortDescriptor(key: "message", ascending: true)
        
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        do {
            commits = try dataContainer.viewContext.fetch(fetchRequest)
            print("Fetched \(commits.count) from our persistent container context")
            tableView.reloadData()
        } catch {
            showError(title: "Error while fetching data from persistent container context", message: error.localizedDescription)
        }
    }
    
    
    func saveData() {
        guard dataContainer.viewContext.hasChanges else { return }
        
        do {
            print("Saving persistent data container view context")
            try dataContainer.viewContext.save()
        } catch {
            showError(title: "Error while saving persistent data store", message: error.localizedDescription)
        }
    }
}

