//
//  ViewController.swift
//  Swift Searcher
//
//  Created by Brian Sipple on 2/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

enum UserDefaultsKey {
    static let favorites = "favorites"
}

let searchDomain = "com.hackingwithswift"

class HomeTableViewController: UITableViewController {
    var projects = [Project]()
    
    lazy var userDefaults = UserDefaults.standard
    
    lazy var safariConfig: SFSafariViewController.Configuration = {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        return config
    }()

    var favoriteProjectNumbers: [Int] {
        return projects.filter({ $0.isFavorite == true }).map({ $0.projectNumber })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadProjectsData()
        loadSavedFavoritesData()
        setupTable()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = projects[indexPath.row]
        
        cell.textLabel?.attributedText = project.tableCellFormat()
        cell.editingAccessoryType = project.isFavorite ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return projects[indexPath.row].isFavorite ? .delete : .insert
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        showWebpage(forProject: project.projectNumber)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        switch editingStyle {
        case .insert:
            project.isFavorite = true
            indexProjectInSpotlight(project)
        case .delete:
            project.isFavorite = false
            deindexProjectInSpotlight(project)
        default:
            break
        }
        
        saveFavoritesData()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func indexProjectInSpotlight(_ project: Project) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        
        attributeSet.title = project.title
        attributeSet.contentDescription = project.subtitle
        
        let searchableItem = CSSearchableItem(
            uniqueIdentifier: "\(project.projectNumber)",
            domainIdentifier: searchDomain,
            attributeSet: attributeSet
        )
        
        searchableItem.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error: Error?) in
            if let error = error {
                print("Error while attempting to index project \(project.projectNumber) in Spotlight: \(error.localizedDescription)")
            } else {
                print("Project \(project.projectNumber) successfully indexed!")
            }
        }
    }
    
    
    func deindexProjectInSpotlight(_ project: Project) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(project.projectNumber)"]) { (error: Error?) in
            if let error = error {
                print("Error while attempting to deindex project \(project.projectNumber) from Spotlight: \(error.localizedDescription)")
            } else {
                print("Project \(project.projectNumber) successfully deindexed!")
            }
        }
    }
    
    
    func setupTable() {
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    

    func loadProjectsData() {
        if let jsonData = loadProjectsJSON() {
            let decoder = JSONDecoder()
            
            do {
                projects = try decoder.decode([Project].self, from: jsonData)
            } catch let error {
                print("Error decoding projects JSON data:\n\(error.localizedDescription)")
            }
        } else {
            print("Unable to find projects JSON data")
        }
    }
    
    
    func loadProjectsJSON() -> Data? {
        if let dataPath = Bundle.main.path(forResource: "projects", ofType: "json") {
            do {
                let dataURL = URL(fileURLWithPath: dataPath)
                return try Data(contentsOf: dataURL)
            } catch let error {
                print("Error while parsing projects json data: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    
    func loadSavedFavoritesData() {
        if let savedFavorites = userDefaults.object(forKey: UserDefaultsKey.favorites) as? [Int] {
            savedFavorites.forEach({ projectNumber in
                if var project = projects.first(where: { $0.projectNumber == projectNumber } ) {
                    project.isFavorite = true
                }
            })
        }
    }
    
    func saveFavoritesData() {
        userDefaults.set(favoriteProjectNumbers, forKey: UserDefaultsKey.favorites)
    }
    
    func showWebpage(forProject projectNumber: Int) {
        let url = URL(string: "https://www.hackingwithswift.com/read/\(projectNumber)")!
        let viewController = SFSafariViewController(url: url, configuration: safariConfig)
        
        present(viewController, animated: true)
    }
}

