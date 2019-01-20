//
//  ViewController.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    var nearEarthObjects = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearEarthObjects.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NEO Cell", for: <#T##IndexPath#>)
        
        cell.textLabel?.text = "Title goes here ⚡️"
        cell.detailTextLabel?.text = "Subtitle goes here ☄️"
    }
    


}

