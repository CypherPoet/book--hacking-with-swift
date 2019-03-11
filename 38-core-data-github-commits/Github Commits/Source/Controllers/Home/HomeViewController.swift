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
    enum CommitFilter {
        static let bugFix = NSPredicate(format: "message CONTAINS[c] 'fix'")
        static let notPR = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
        static let last24Hours = NSPredicate(format: "date > %@", Date().addingTimeInterval(-86_400) as NSDate)
        static let allCommits: NSPredicate? = nil
    }
    
    // MARK: - Instance Properties
    
    let cellReuseIdentifier = "Commit Cell"
    var dataContainer: NSPersistentContainer!
    var commits: [Commit] = []
    
    var currentCommitFilter: NSPredicate? = CommitFilter.allCommits {
        didSet { loadSavedData() }
    }
    
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
    
    
    // MARK: - Data Source
    
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
        fetchRequest.predicate = currentCommitFilter
        
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
    
    
    
    // MARK: - Event handling

    @IBAction func filterButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter Commits", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Bug Fixes Only", style: .default) { [weak self] _ in
            self?.currentCommitFilter = CommitFilter.bugFix
        })
        
        alertController.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [weak self] _ in
            self?.currentCommitFilter = CommitFilter.notPR
        })

        alertController.addAction(UIAlertAction(title: "Last 24 Hours", style: .default) { [weak self] _ in
            self?.currentCommitFilter = CommitFilter.last24Hours
        })
        
        alertController.addAction(UIAlertAction(title: "Show All Commits", style: .default) { [weak self] _ in
            self?.currentCommitFilter = CommitFilter.allCommits
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}

