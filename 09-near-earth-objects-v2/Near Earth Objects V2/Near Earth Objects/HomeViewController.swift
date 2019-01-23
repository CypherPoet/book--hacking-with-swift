//
//  ViewController.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    let apiURL = "https://api.nasa.gov/neo/rest/v1/neo/browse?api_key=DEMO_KEY"
    var closeApproachAsteroids = [Asteroid]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        performSelector(inBackground: #selector(loadAsteroids), with: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closeApproachAsteroids.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Asteroid Cell", for: indexPath)
        let asteroid = closeApproachAsteroids[indexPath.row]
        
        cell.textLabel?.text = asteroid.name
        
        if let closeApproachDate = asteroid.closeApproachDate {
            cell.detailTextLabel?.text = "Close-approach date: \(closeApproachDate)"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = AsteroidDetailViewController()
        
        detailVC.asteroid = closeApproachAsteroids[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    

    @objc func loadAsteroids() {
        if let apiURL = URL(string: apiURL) {
            if let data = try? Data(contentsOf: apiURL) {
                closeApproachAsteroids = parseAsteroidData(data: data)
                print("Number of close approaches: \(closeApproachAsteroids.count)")
                
                tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    func parseAsteroidData(data: Data) -> [Asteroid] {
        let decoder = JSONDecoder()
        
        if let asteroidsJSON = try? decoder.decode(Asteroids.self, from: data) {
            let asteroids = asteroidsJSON.nearEarthObjects
            print("Fetched \(asteroids.count) asteroids")
            
            return asteroids.filter({ $0.closeApproachDate != nil })
        } else {
            print("Unable to fetch asteroid JSON")
            
            return [Asteroid]()
        }
    }
    
    
    @objc func showError() {
        let alertController = UIAlertController(
            title: "Error Loading Data",
            message: "There was a problem loading the feed. Please check your connection and try again.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "👌 OK", style: .default))
        
        present(alertController, animated: true)
    }
}

