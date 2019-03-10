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
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let commit = commits[indexPath.row]
        
        cell.textLabel?.text = commit.sha
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
                fatalError("Error fetching data from Github API: \(error.localizedDescription)")
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
            commits = try decoder.decode([Commit].self, from: json)
            print("Received \(commits.count) new commits")
            
            DispatchQueue.main.async { [weak self] in
                // TODO: more with commits here?
                self?.saveData()
            }
        } catch {
            print("Error while parsing `Commit` json data:\n\n\(error.localizedDescription)")
        }
    }
    
    
    func saveData() {
        guard dataContainer.viewContext.hasChanges else { return }
        
        do {
            print("Saving persistent data container view context")
            try dataContainer.viewContext.save()
        } catch {
            print("Error while saving persistent data store: \(error.localizedDescription)")
        }
    }
}

