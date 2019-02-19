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
    @IBOutlet weak var viewModeButton: UIBarButtonItem!
    
    var photos = [UIImage]()
    
    var currentViewMode = ViewMode.publicFacing {
        didSet {
            viewModeChanged()
        }
    }
    
    var documentsDirectoryURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadImages()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.imageView.image = photo
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        if let detailViewController = (
            storyboard?.instantiateViewController(withIdentifier: "Photo Detail View") as?  PhotoDetailViewController
        ) {
            detailViewController.photo = photo
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false
        super.viewWillDisappear(animated)
    }


    func viewModeChanged() {
        switch currentViewMode {
        case .publicFacing:
            title = NavContent.Title.publicFacing
            viewModeButton.title = NavContent.viewModeToggle.publicFacing
        case .privatePhotos:
            title = NavContent.Title.privatePhotos
            viewModeButton.title = NavContent.viewModeToggle.privatePhotos
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
        for imageNumber in 1...9 {
            if let image = UIImage(named: "nasa-\(imageNumber)") {
                photos.append(image)
            }
        }
    }
    
    func promptForAddingPhoto() {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        present(pickerController, animated: true)
    }
    
    /*
     - Generate a unique filename for the image.
     - Convert it to a JPEG
     - Write that JPEG to disk.
     */
    func saveImageToDisk(_ image: UIImage) {
        let fileName = UUID().uuidString
        let imageURL = diskURL(forFileName: fileName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            do {
                try jpegData.write(to: imageURL)
            } catch let error {
                print("Error while trying to write jpegData to disk: \(error.localizedDescription)")
            }
        }
    }
    
    
    func diskURL(forFileName fileName: String) -> URL {
        return documentsDirectoryURL.appendingPathComponent(fileName)
    }
    
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        promptForAddingPhoto()
    }
}


extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let imagePicked = info[.editedImage] as? UIImage else { return }
        
        // Only save images in "private" mode. Public mode will merely provide the illusion that this is happening 😃
        if currentViewMode == .privatePhotos {
            saveImageToDisk(imagePicked)
        }
        
        photos.append(imagePicked)
        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
    
}


extension HomeViewController: UINavigationControllerDelegate {
    
}


