//
//  ImageDetailViewController.swift
//  Private Gallery
//
//  Created by Brian Sipple on 2/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupImageView()
    }
    
    func setupImageView() {
        guard imageView != nil else { return }
        guard photo != nil else { return }
        
        imageView.image = photo
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
