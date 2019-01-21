//
//  ViewController.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    var asteroids = [Asteroid]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadAsteroids()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroids.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Asteroid Cell", for: indexPath)
        let asteroid = asteroids[indexPath.row]
        
        cell.textLabel?.text = asteroid.name
        
        if let closeApproachDate = asteroid.closeApproachDate {
            cell.detailTextLabel?.text = "Close-approach date: \(closeApproachDate)"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    

    func loadAsteroids() {
        let urlString = "https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY"
        
        if let apiURL = URL(string: urlString) {
            if let data = try? Data(contentsOf: apiURL) {
                parseAsteroidData(data: data)
            }
        }
    }
    
    func parseAsteroidData(data: Data) {
        let decoder = JSONDecoder()
        
        if let responseJSON = try? decoder.decode(Asteroids.self, from: data) {
            asteroids = responseJSON.nearEarthObjects
            print("Fetched \(asteroids.count) asteroids")
            tableView.reloadData()
        } else {
            print("Unable to fetch asteroid JSON")
        }
    }
}

