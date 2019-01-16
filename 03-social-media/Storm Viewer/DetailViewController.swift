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
    
    var selectedImagePath: String?
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return navigationController?.hidesBarsOnTap ?? false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImagePath
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareTapped)
        )
        
        if let _imagePath = selectedImagePath {
            imageView.image = UIImage(named: _imagePath)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnTap = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    @objc func shareTapped() {
        let controller = UIActivityViewController(
            activityItems: [imageView.image!],
            applicationActivities: []
        )
        
        // tell iOS where the controller should be anchored
        controller.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(controller, animated: true)
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
