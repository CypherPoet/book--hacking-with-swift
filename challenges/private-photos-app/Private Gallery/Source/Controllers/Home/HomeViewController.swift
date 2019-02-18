//
//  ViewController.swift
//  Private Gallery
//
//  Created by Brian Sipple on 2/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import KeychainAccess
import LocalAuthentication


enum ViewMode {
    case publicFacing
    case privatePhotos
}

enum KeychainAccessKey {
    static let passphrase = "passphrase"
}

enum NavContent {
    enum Title {
        static let publicFacing = "🛰 Nasa Gallery"
        static let privatePhotos = "👾 Welcome In"
    }
    enum viewModeToggle {
        static let publicFacing = "🚀"
        static let privatePhotos = "🙈"
    }
}


class HomeViewController: UICollectionViewController {
    @IBOutlet weak var signInButton: UIBarButtonItem!
    
    var photos = [UIImage]()
    
    var currentViewMode = ViewMode.publicFacing {
        didSet {
            viewModeChanged()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadImages()
    }


    func viewModeChanged() {
        switch currentViewMode {
        case .publicFacing:
            title = NavContent.Title.publicFacing
        case .privatePhotos:
            title = NavContent.Title.privatePhotos
        }
        
        loadImages()
    }
    
    
    func loadImages() {
        switch currentViewMode {
        case .publicFacing:
            loadPublicPhotos()
        case .privatePhotos:
            loadPrivatePhotos()
        }
    }
    
    func loadPrivatePhotos() {
        
    }
    
    func loadPublicPhotos() {
        
    }
    
    
    @IBAction func addPhotoTapped(_ sender: Any) {
    }
    
}

