//
//  AsteroidDetailView.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit

class AsteroidDetailViewController: UIViewController {
    var webView: WKWebView!
    var asteroid: Asteroid?
    
    override func loadView() {
        webView = WKWebView()
        
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageHTML = makePageHTML()
        webView.loadHTMLString(pageHTML, baseURL: nil)
    }
    
    
    /*
     // The HTML we're going to use tells iOS that the page fits mobile devices,
     // and that we want the font size to be 150% of the standard font size.
     //
     // All that HTML will be combined with the body value from our petition, then sent to the web view.
     */
    func makePageHTML() -> String {
        guard let asteroid = asteroid else { return "" }
        
        var nearMissHTML = ""
        if let closeApproachDate = asteroid.closeApproachDate {
            if let missDistanceKM = asteroid.missDistanceKM {
                nearMissHTML = """
                <p>
                    The asteroid made its closest approach to Earth on \(closeApproachDate) &mdash; passing
                    within \(missDistanceKM) kilometers!
                </p>
                """
            }
        }

        let html = """
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8" />
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <title>\(asteroid.name)</title>
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <style>
                body {
                    font-size: 150%;
                    padding: 1.25rem 1rem;
                }
              </style>
            </head>
            <body>
                <p>
                    Asteroid "\(asteroid.name)" (officially designated as "\(asteroid.designation)" has an
                    <a href="https://en.wikipedia.org/wiki/Absolute_magnitude#Solar_System_bodies_(H)">absolute magnitude</a> of
                    \(asteroid.absoluteMagnitudeH)
                </p>
                \(nearMissHTML)
        
                <p>
                    Visit this asteriod's <a href="\(asteroid.jplURL.absoluteURL)">NASA JPL's page</a> to learn more
                </p>
            </body>
            </html>
        """
        
        return html
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
