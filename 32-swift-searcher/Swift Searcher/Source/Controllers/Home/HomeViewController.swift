//
//  ViewController.swift
//  Swift Searcher
//
//  Created by Brian Sipple on 2/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SafariServices

class HomeTableViewController: UITableViewController {
    var projects = [Project]()
    
    var safariConfig: SFSafariViewController.Configuration {
        let config = SFSafariViewController.Configuration()
        
        config.entersReaderIfAvailable = true
        
        return config
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadProjects()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = projects[indexPath.row]
        
        cell.textLabel?.attributedText = project.tableCellFormat()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        showWebpage(forProject: project.projectNumber)
    }
    

    func loadProjects() {
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
    
    func showWebpage(forProject projectNumber: Int) {
        let url = URL(string: "https://www.hackingwithswift.com/read/\(projectNumber)")!
        let viewController = SFSafariViewController(url: url, configuration: safariConfig)
        
        present(viewController, animated: true)
    }
}

