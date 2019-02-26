//
//  SelectGenreTableViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SelectGenreTableViewController: UITableViewController {
    static let cellReuseIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SelectGenreTableViewController.cellReuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Genre.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectGenreTableViewController.cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = Genre.allCases[indexPath.row].rawValue
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genre = Genre.allCases[indexPath.row]
        let viewController = AddCommentsViewController()
        
        viewController.genre = genre
        
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    func setupNavbar() {
        title = "Select a Genre"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .plain, target: nil, action: nil)
    }

}
