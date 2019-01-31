//
//  ViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 1/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    var cities = [City]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadCities()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "City Cell")!
        let city = cities[indexPath.row]
        
        cell.imageView?.image = UIImage(named: city.backgroundImageName)
        cell.textLabel?.text = city.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityDetailVC = storyboard?.instantiateViewController(withIdentifier: "City Details") as? CityDetailViewController {
            let city = cities[indexPath.row]
            
            cityDetailVC.city = city

            navigationController?.pushViewController(cityDetailVC, animated: true)
        }
    }
    
    
    func loadCities() {
        if let dataPath = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let cityData = try Data(contentsOf: URL(fileURLWithPath: dataPath))
                let decoder = JSONDecoder()
                let citiesJSON = try decoder.decode(Cities.self, from: cityData)
                
                cities = citiesJSON.cities
                
            } catch let error {
                print("Error while parsing city data: \(error.localizedDescription)")
            }
        } else {
            print("Invalid path for city data")
        }
        
    }
}

