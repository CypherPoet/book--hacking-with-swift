//
//  AuthorCommitsListViewController.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreData

class AuthorCommitsListViewController: UITableViewController {

    // MARK: - Instance Properties

    var persistentDataContainer: NSPersistentContainer!
    lazy var fetchedResultsController: NSFetchedResultsController<Commit> = makeFetchedResultsController()
    
    var author: Author!
    
    
    // MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Commits by \(author.name)"
        loadSavedData()
    }
}


// MARK: - Table view data source

extension AuthorCommitsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("fetchResultsController has no sections")
        }
        
        return sections.count
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
        cell.detailTextLabel?.text = "Committed on \(commit.date.description)"
        
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}


// MARK: - Helper functions

private extension AuthorCommitsListViewController {
    func makeFetchedResultsController() -> NSFetchedResultsController<Commit> {
        let fetchRequest = Commit.createFetchRequest()
        
        let sortDescriptors = [
            Commit.SortDescriptor.dateDesc,
            Commit.SortDescriptor.messageAsc
        ]
        
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = NSPredicate(format: "author.name == %@", author.name)
        
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: persistentDataContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func loadSavedData() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            showError(error, title: "Error while fetching data from persistent container context")
        }
    }
}
