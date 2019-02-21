//
//  ViewController.swift
//  Swift Searcher
//
//  Created by Brian Sipple on 2/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var projects = [Project]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadProjects()
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
}

