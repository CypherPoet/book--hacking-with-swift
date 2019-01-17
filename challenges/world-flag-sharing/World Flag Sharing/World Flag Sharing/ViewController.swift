//
//  ViewController.swift
//  World Flag Sharing
//
//  Created by Brian Sipple on 1/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

let flagAssetNamesAndLabels = [
    "estonia": "Estonia",
    "france": "France",
    "germany": "Germany",
    "ireland": "Ireland",
    "italy": "Italy",
    "monaco": "Monaco",
    "nigeria": "Nigeria",
    "poland": "Poland",
    "russia": "Russia",
    "spain": "Spain",
    "uk": "United Kingdom",
    "us": "United States",
]


class ViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagAssetNamesAndLabels.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag List Item", for: indexPath) as! FlagTableViewCell
        let flagAssetName = Array(flagAssetNamesAndLabels.keys.sorted())[indexPath.row]
        let flagLabel = flagAssetNamesAndLabels[flagAssetName]
        
        cell.flagImage?.image = UIImage(named: flagAssetName)
        cell.flagNameLabel?.text = flagLabel?.capitalized
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // load the detail view controller on to the navigation controller stack
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "Flag Detail") as? DetailViewController {
            let flagAssetName = Array(flagAssetNamesAndLabels.keys.sorted())[indexPath.row]
            let flagName = flagAssetNamesAndLabels[flagAssetName]
            
            detailVC.selectedImageAsset = flagAssetName
            detailVC.flagName = flagName
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

