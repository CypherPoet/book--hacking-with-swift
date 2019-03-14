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
    
    var words: [String] {
        return playData.filteredWords
    }
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


// MARK: - Event handling

extension HomeViewController {
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Show words that include:", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak alertController] _ in
            if
                let text = alertController?.textFields?.first?.text,
                !text.isEmpty
            {
                self?.playData.applyCustomFilter({ $0.lowercased().contains(text) })
            } else {
                self?.playData.setCountThreshold(0)
            }
            
            self?.tableView.reloadData()
        })
        
        present(alertController, animated: true)
    }
}

