//
//  ViewController.swift
//  Names And Faces
//
//  Created by Brian Sipple on 1/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        
        return cell
    }
    
    
    /*
     Handles the completion of adding an image to the picker. Our flow:
        - Extract the image from the dictionary that is passed as a parameter.
        - Generate a unique filename for it.
        - Convert it to a JPEG
        - Write that JPEG to disk.
        - Dismiss the view controller.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[.editedImage] as? UIImage else { return }

        let fileName = UUID().uuidString
        let imagePath = getDocumentsDirectoryURL().appendingPathComponent(fileName)
        
        if let jpegData = imagePicked.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        picker.dismiss(animated: true)
    }
    
    
    @objc func addNewPerson() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    
    func getDocumentsDirectoryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
}

