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
    
    var persistentDataContainer: NSPersistentContainer!
    lazy var fetchedResultsController = makeFetchedResultsController()
    
    var currentCommitFilter: NSPredicate? = Commit.Predicate.allCommits {
        didSet { loadSavedData() }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard persistentDataContainer != nil else {
            fatalError("HomeViewController needs a persistent data container")
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fetchCommits()
        }
        
        loadSavedData()
    }
}
    

// MARK: - Data Source

extension HomeViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in `fetchedResultsController`")
        }
        
        return sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in `fetchedResultsController`")
        }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardID.TableCell.commit, for: indexPath)
        let commit = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = commit.message
        cell.detailTextLabel?.text = "By \(commit.author.name) on \(commit.date.description)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?
            .instantiateViewController(withIdentifier: StoryboardID.ViewController.commitDetail)
            as? CommitDetailViewController
        {
            detailViewController.commit = fetchedResultsController.object(at: indexPath)
            detailViewController.persistentDataContainer = persistentDataContainer
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = fetchedResultsController.object(at: indexPath)
            
            persistentDataContainer.viewContext.delete(commit)
            saveDataContext()
        }
    }
}

    
// MARK: - Helper Methods

private extension HomeViewController {
    
    func fetchCommits() {
        let newestCommitDateString = ISO8601DateFormatter()
            .string(from: Commit.newestCommitDate(in: persistentDataContainer.viewContext))
        
        let urlString = "\(GithubAPI.commits)?" +
            "\(GithubAPI.QueryParams.perPage)=1000&" +
            "\(GithubAPI.QueryParams.sinceDate)=\(newestCommitDateString)"
        
        if let commitsURL = URL(string: urlString) {
            do {
                let data = try Data(contentsOf: commitsURL)
                parseCommits(fromJSON: data)
            } catch {
                showError(error, title: "Error fetching data from Github API")
            }
        } else {
            fatalError("Error constructing URL to GitHub API")
        }
    }
    
    
    func parseCommits(fromJSON json: Data) {
        guard let mangedObjectContextKey = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retreive managedObjectContext coding key")
        }
        
        let managedObjectContext = persistentDataContainer.viewContext
        let decoder = JSONDecoder()
        
        decoder.userInfo[mangedObjectContextKey] = managedObjectContext
        
        do {
            let commits = try decoder.decode([Commit].self, from: json)
            print("Parsed \(commits.count) new commits from the API")
            
            DispatchQueue.main.async { [weak self] in
                self?.saveDataContext()
                self?.loadSavedData()
            }
        } catch {
            showError(error, title: "Error while parsing `Commit` json data")
        }
    }
    
    
    func loadSavedData() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            showError(error, title: "Error while fetching data from persistent container context")
        }
    }
    
    
    func saveDataContext() {
        guard persistentDataContainer.viewContext.hasChanges else { return }
        
        do {
            print("Saving persistent data container view context")
            try persistentDataContainer.viewContext.save()
        } catch {
            showError(error, title: "Error while saving persistent data store")
        }
    }
    
    
    func makeFetchedResultsController() -> NSFetchedResultsController<Commit> {
        let fetchRequest = Commit.dateSortedFetchRequest
        
        fetchRequest.sortDescriptors?.insert(Commit.SortDescriptor.authorNameAsc, at: 0)
        fetchRequest.predicate = currentCommitFilter
        fetchRequest.fetchBatchSize = 20
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentDataContainer.viewContext,
            sectionNameKeyPath: "author.name",
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }
}
    

// MARK: - Event handling

extension HomeViewController {
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter Commits", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Bug Fixes Only", style: .default) { [weak self] _ in
            self?.currentCommitFilter = Commit.Predicate.bugFix
        })
        
        alertController.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [weak self] _ in
            self?.currentCommitFilter = Commit.Predicate.notPR
        })

        alertController.addAction(UIAlertAction(title: "Last 24 Hours", style: .default) { [weak self] _ in
            self?.currentCommitFilter = Commit.Predicate.last24Hours
        })
        
        alertController.addAction(UIAlertAction(title: "Show All Commits", style: .default) { [weak self] _ in
            self?.currentCommitFilter = Commit.Predicate.allCommits
        })
        
        alertController.addAction(UIAlertAction(title: "Show Only Durian Commits", style: .default) { [weak self] _ in
            self?.currentCommitFilter = Commit.Predicate.durianCommits
        })

        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension HomeViewController: NSFetchedResultsControllerDelegate {

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        guard let indexPath = indexPath else { return }
        
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
}
