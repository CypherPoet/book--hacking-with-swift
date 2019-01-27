//
//  StormDetailViewController.swift
//  Storm Viewer 2
//
//  Created by Brian Sipple on 1/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class StormDetailViewController: UIViewController {
    @IBOutlet weak var stormImageView: UIImageView!
    
    var imagePath: String?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return navigationController?.hidesBarsOnTap ?? false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imagePath = imagePath {
            title = imagePath
            navigationItem.largeTitleDisplayMode = .never
            
            stormImageView.image = UIImage(named: imagePath)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.hidesBarsOnTap = false
    }

}
