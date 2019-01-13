//
//  DetailViewController.swift
//  Storm Viewer
//
//  Created by Brian Sipple on 1/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _imagePath = imagePath {
            imageView.image = UIImage(named: _imagePath)
        }
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
