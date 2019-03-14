//
//  ViewController.swift
//  iOS Unit Testing
//
//  Created by Brian Sipple on 3/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    lazy var playData = PlayData()
    lazy var words = playData.filteredWords
}


// MARK: - Lifecycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playData.applyCustomFilter({ $0.lowercased().contains("swift") })
    }
}


// MARK: - Data Source

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardID.TableView.cell, for: indexPath)
        let word = words[indexPath.row]
        
        cell.textLabel?.text = word
        cell.detailTextLabel?.text = "\(playData.wordCounts.count(for: word)) counts"
        
        return cell
    }
}

