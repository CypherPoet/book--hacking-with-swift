//
//  ViewController.swift
//  Guess the Song
//
//  Created by Brian Sipple on 2/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CloudKit

class HomeViewController: UITableViewController {
    let cellReuseIdentifier = "Cell"
    var soundBites: [SoundBite] = []
    static var hasNewSoundBiteData = true
    
    lazy var cellTitleStringAttributes = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.4665188789, green: 0.4245759249, blue: 0.8790055513, alpha: 1),
    ]
    
    lazy var cellSubtitleStringAttributes = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline),
    ]
    
    let queryResultsLimit = 50
    lazy var publicCloudDB = CKContainer.default().publicCloudDatabase
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        clearsSelectionOnViewWillAppear = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if HomeViewController.hasNewSoundBiteData {
            loadSoundBites()
        }
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundBites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let soundBite = soundBites[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.attributedText = makeCellString(title: soundBite.genre, subtitle: soundBite.comments)
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundBite = soundBites[indexPath.row]
        let viewController = SoundResultsTableViewController()
        
        viewController.soundBite = soundBite
        
        navigationController?.pushViewController(viewController, animated: true)
    }

    
    // MARK: - Helper functions
    
    func loadSoundBites() {
        let queryOperation = makeSoundBitesQueryOperation()
        var newRecords: [SoundBite] = []
        
        queryOperation.recordFetchedBlock = { record in
            newRecords.append(SoundBite(record: record))
        }
        
        queryOperation.queryCompletionBlock = {
            (cursor: CKQueryOperation.Cursor?, error: Error?) in
                DispatchQueue.main.async {
                    if error == nil {
                        HomeViewController.hasNewSoundBiteData = false
                        self.soundBites = newRecords
                        self.tableView.reloadData()
                    } else {
                        self.displayBasicAlert(
                            title: "Fetch failed",
                            message: "There was a problem fetching the list of sound bites. Please try again.\nError: \(error!.localizedDescription)"
                        )
                    }
                }
        }
        
        publicCloudDB.add(queryOperation)
    }
    
    
    func makeCellString(title: String, subtitle: String) -> NSAttributedString {
        let titleString = NSMutableAttributedString(string: title, attributes: cellTitleStringAttributes)
        
        if !subtitle.isEmpty {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: cellSubtitleStringAttributes)
            
            titleString.append(subtitleString)
        }
        
        return titleString
    }
    
    
    // MARK: - Action handling
    
    @IBAction func addSound(_ sender: Any) {
        let vc = RecordSoundViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Private functions
    
    private func makeSoundBitesQueryOperation() -> CKQueryOperation {
        let predicate = NSPredicate(value: true)
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        
        let query = CKQuery(recordType: AppCKRecordType.soundBites, predicate: predicate)
        query.sortDescriptors = [sortDescriptor]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comments"]
        operation.resultsLimit = queryResultsLimit
        
        return operation
    }
}

