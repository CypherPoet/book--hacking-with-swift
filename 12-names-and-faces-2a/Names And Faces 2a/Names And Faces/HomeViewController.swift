//
//  ViewController.swift
//  Names And Faces
//
//  Created by Brian Sipple on 1/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people: [Person]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as! PersonCell
        let person = people[indexPath.item]
        
        cell.personImageView.image = UIImage(contentsOfFile: getURL(forFile: person.imageName).path)
        cell.personNameLabel.text = person.name
        
        setStyles(forCell: cell)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        promptForName(of: person)
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
        let imageURL = getURL(forFile: fileName)
        
        if let jpegData = imagePicked.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imageURL)
        }
        
        people.append(Person(name: "Unknown", imageName: fileName))
        saveData()
        collectionView?.reloadData()
        
        picker.dismiss(animated: true)
    }
    
    
    @objc func addNewPerson() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 📝 TODO: Add additional logic to ask the user if they'd like to use their device camera
            // imagePicker.sourceType = .camera
        }
        
        present(imagePicker, animated: true)
    }
    
    
    func getDocumentsDirectoryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    
    func getURL(forFile fileName: String) -> URL {
        return getDocumentsDirectoryURL().appendingPathComponent(fileName)
    }
    
    
    func setStyles(forCell cell: PersonCell) {
        cell.personImageView.layer.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor
        cell.personImageView.layer.borderWidth = 2
        cell.personImageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
    }
    
    
    func promptForName(of person: Person) {
        let alertController = UIAlertController(title: "Who is this?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(
            UIAlertAction(title: "OK", style: .default) { [unowned self, alertController] _ in
                let newName = alertController.textFields![0].text!
                
                person.name = newName
                
                self.saveData()
                self.collectionView?.reloadData()
            }
        )
        
        present(alertController, animated: true)
    }
    
    
    func saveData() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            
            defaults.set(savedData, forKey: "people")
        }
    }
    
    
    func loadData() {
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [Person] {
                people = decodedPeople ?? [Person]()
            }
        }
    }
}

