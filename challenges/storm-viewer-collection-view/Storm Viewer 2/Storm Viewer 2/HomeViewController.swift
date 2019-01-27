//
//  ViewController.swift
//  Storm Viewer 2
//
//  Created by Brian Sipple on 1/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    var stormImagePaths = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer ⚡️"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadImages()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stormImagePaths.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Storm Cell", for: indexPath) as! StormCollectionViewCell
        
        cell.stormImage.image = UIImage(named: stormImagePaths[indexPath.item])
        cell.stormLabel.text = stormImagePaths[indexPath.item]
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "Storm Detail View") as! StormDetailViewController
        
        viewController.imagePath = stormImagePaths[indexPath.item]
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    

    func loadImages() {
        guard let resourcePath = Bundle.main.resourcePath else { return }
        
        let fileManager = FileManager.default
        let items = try! fileManager.contentsOfDirectory(atPath: resourcePath)
        
        stormImagePaths = items.filter({ $0.hasSuffix(".jpg") })
    }
}

