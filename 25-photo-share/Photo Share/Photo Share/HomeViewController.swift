//
//  ViewController.swift
//  Photo Share
//
//  Created by Brian Sipple on 2/11/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
    @IBOutlet weak var importPhotoButton: UIBarButtonItem!
    
    var photos: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func importPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo Cell", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = photos[indexPath.item]
        }
        
        return cell
    }
}

extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.dismiss(animated: true)
        self.photos.insert(image, at: 0)
        self.collectionView?.reloadData()
    }
}

