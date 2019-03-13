//
//  CommitDetailViewController.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreData

class CommitDetailViewController: UIViewController {
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var moreCommitsButton: UIButton!
    

    // MARK: - Instance Properties
    
    var commit: Commit!
    var persistentDataContainer: NSPersistentContainer!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard commit != nil else { return }
        
        setupUI()
    }
}


// MARK: - Core Methods

extension CommitDetailViewController {
    func setupUI() {
        detailLabel.text = commit.message
//        moreCommitsButton.setTitle("More Commits by \(commit.author.name)", for: .normal)
    }
}


// MARK: - Event handling

extension CommitDetailViewController {
    @IBAction func moreCommitsButtonTapped(_ sender: Any) {
        guard let viewController = storyboard?
            .instantiateViewController(withIdentifier: StoryboardID.ViewController.authorCommitsList)
            as? AuthorCommitsListViewController
        else {
            return
        }
        
        viewController.author = commit.author
        viewController.persistentDataContainer = persistentDataContainer
        navigationController?.pushViewController(viewController, animated: true)
    }
}
