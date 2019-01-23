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
        performSelector(inBackground: #selector(loadHistoryStats), with: nil)
    }
    

    @objc func loadHistoryStats() {
        if let url = URL(string: apiURL) {
            if let requestData = try? Data(contentsOf: url) {
                historyData = parseHistoryData(data: requestData)
                
                updateUIOnLoad()
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    func parseHistoryData(data: Data) -> NEOHistory? {
        let decoder = JSONDecoder()
        
        return try? decoder.decode(NEOHistory.self, from: data)
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
    
    
    /*
     📝 We could also call this via `performSelector` and designate it as being runnable in Objective-C
        This approach just shows another way of the function itself guaranteeing that it's using the main thread
     */
    func updateUIOnLoad() {
        DispatchQueue.main.async { [unowned self] in
            if let historyData = self.historyData {
                self.neoCountLabel.text = String(historyData.nearEarthObjectCount)
                self.closeApproachCountLabel.text = String(historyData.closeApproachCount)
                self.jplSourceLabel.text = historyData.source
            }
        }
    }
}
