//
//  DetailViewController.swift
//  World Flag Sharing
//
//  Created by Brian Sipple on 1/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var flagImageView: UIImageView!
    
    var selectedImageAsset: String?
    var flagName: String?
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareFlag)
        )
        
        if let currentFlagName = flagName {
            title = currentFlagName
        }
        
        if let flagAssetName = selectedImageAsset {
            flagImageView.image = UIImage(named: flagAssetName)
            flagImageView.layer.shadowRadius = 3.0
            flagImageView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0);
            flagImageView.layer.shadowOpacity = 1.0
            flagImageView.layer.shadowColor = UIColor(red: 0.13, green: 0.14, blue: 0.21, alpha: 0.75).cgColor
        }
    }
    
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return navigationController?.hidesBarsOnTap ?? false
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
    

    @objc func shareFlag() {
        let activityVC = UIActivityViewController(activityItems: [flagImageView.image!], applicationActivities: [])
        
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
}
