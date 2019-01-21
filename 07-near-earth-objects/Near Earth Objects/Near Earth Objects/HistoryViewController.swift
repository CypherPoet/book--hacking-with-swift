//
//  HistoryViewController.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
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
            }
        }
    }
    
    
    func parseHistoryData(data: Data) -> NEOHistory? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(NEOHistory.self, from: data)
    }
}
