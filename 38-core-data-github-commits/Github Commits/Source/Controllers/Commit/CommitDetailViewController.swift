//
//  CommitDetailViewController.swift
//  Github Commits
//
//  Created by Brian Sipple on 3/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CommitDetailViewController: UIViewController {
    @IBOutlet var detailLabel: UILabel!
    
    
    // MARK: - Instance Properties
    
    var commit: Commit!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard commit != nil else { return }
        
        setupUI()
    }
    

    // MARK: - Core Methods
    
    func setupUI() {
        detailLabel.text = commit.message
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
