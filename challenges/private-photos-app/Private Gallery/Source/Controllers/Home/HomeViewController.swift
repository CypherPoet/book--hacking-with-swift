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

    let authReason = "We'll need to see some ID"
    lazy var authContext = LAContext()
    
    var photos = [UIImage]()
    
    var currentViewMode = ViewMode.publicFacing {
        didSet {
            viewModeChanged()
        }
    }
    
    var documentsDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
        
        photos.removeAll(keepingCapacity: true)
        loadImages()
        collectionView.reloadData()
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
        let fileManager = FileManager.default
        
        do {
            let imageURLS = try fileManager.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil)
            
            print(imageURLS)
            
            for url in imageURLS {
                if let photo = loadPhoto(fromURL: url) {
                    photos.append(photo)
                }
            }
            
        } catch let error {
            print("Error loading image paths from disk: \(error.localizedDescription)")
        }
    }
    
    
    func loadPhoto(fromURL url: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
        
        return nil
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
    
    
    func authWithFaceId() {
        authContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: authReason,
            reply: { (success: Bool, error: Error?) -> Void in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.currentViewMode = .privatePhotos
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        )
    }
    
    
    func authWithPassword() {
        print("📝 TODO: Auth with Password")
    }
    
    
    func performAuthentication() {
        var authError: NSError?
        
        authContext.localizedCancelTitle = "Use a username and password"
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authWithFaceId()
        } else if authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            // attempt to fallback to a passcode when biometrics fails or is unavailable
            authWithPassword()
        }
    }
    
    
    @IBAction func addPhotoTapped(_ sender: Any) {
        promptForAddingPhoto()
    }
    
    
    @IBAction func viewModeButtonTapped(_ sender: Any) {
        if currentViewMode == .privatePhotos {
            currentViewMode = .publicFacing
        } else {
            performAuthentication()
        }
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


