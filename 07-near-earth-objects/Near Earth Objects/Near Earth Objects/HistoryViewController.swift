//
//  HistoryViewController.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var neoCountLabel: UILabel!
    @IBOutlet weak var closeApproachCountLabel: UILabel!
    @IBOutlet weak var jplSourceLabel: UILabel!
    
    let apiURL = "https://api.nasa.gov/neo/rest/v1/stats?api_key=DEMO_KEY"
    var historyData: NEOHistory?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadHistoryStats()
    }
    

    func loadHistoryStats() {
        if let url = URL(string: apiURL) {
            if let requestData = try? Data(contentsOf: url) {
                historyData = parseHistoryData(data: requestData)
                updateUIOnLoad()
                
                return
            }
        }
        showError()
    }
    
    
    func parseHistoryData(data: Data) -> NEOHistory? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(NEOHistory.self, from: data)
    }
    
    
    func showError() {
        let alertController = UIAlertController(
            title: "Error Loading Data",
            message: "There was a problem loading the feed. Please check your connection and try again.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "👌 OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    
    func updateUIOnLoad() {
        if let historyData = historyData {
            neoCountLabel.text = String(historyData.nearEarthObjectCount)
            closeApproachCountLabel.text = String(historyData.closeApproachCount)
            jplSourceLabel.text = historyData.source
        }
    }
}
