//
//  ViewController.swift
//  World Flag Sharing
//
//  Created by Brian Sipple on 1/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var flagImagePaths: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileManager = FileManager.default
        let flagImagesPath = "(Bundle.main.resourcePath!)/flags"
        
        flagImagePaths = try! fileManager.contentsOfDirectory(atPath: flagImagesPath)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagImagePaths.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // load the detail view controller on to the navigation controller stack
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Flag Detail") as? DetailViewController {
            detailVC.selectedImagePath = flagImagePaths[indexPath.row]
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

