//
//  CityDetailViewController.swift
//  City Facts
//
//  Created by Brian Sipple on 1/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateFoundedLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    var city: City!
    
    
//    override func loadView() {
//        webView = WKWebView()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = city.name
        
        setupUI()
//        webView.loadHTMLString(makeHTML(), baseURL: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func makeHTML() -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>\(city.name)</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        
        </style>
        </head>
        <body>
            <header>
              <img src="" alt="">

              <h1>\(city.name)</h1>
            </header>

            <section>
                <p>
                    \(city.description)
                </p>
            </section>
        </body>
        </html>
        """
    }
    
    
    func setupUI() {
        headerImageView.image = UIImage(named: city.backgroundImageName)
        flagImageView.image = UIImage(named: city.flagImageName)
        
        cityNameLabel.text = city.name
        countryLabel.text = "Country: \(city.country)"
        dateFoundedLabel.text = "Date Founded: \(city.yearFounded)"
        populationLabel.text = "Population: \(String(city.population))"
        descriptionText.text = city.description
    }

}
