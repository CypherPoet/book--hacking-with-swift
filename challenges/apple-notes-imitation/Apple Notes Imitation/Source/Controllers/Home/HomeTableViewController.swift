//
//  ViewController.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/3/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    @IBOutlet weak var newFolderButton: UIBarButtonItem!
    
    var folders = [Folder]()
    var newFolderSaveAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        loadFolders()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Folder Cell") as! FolderTableViewCell
        let folder = folders[indexPath.row]
        
        cell.folder = folder
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let notesListViewController = storyboard?.instantiateViewController(withIdentifier: "Notes List") as? NotesListViewController {
            let notes = folders[indexPath.row].notes
        
            notesListViewController.notes = notes
            
            navigationController?.pushViewController(notesListViewController, animated: true)
        }
    }


    func loadFolders() {
        let userDefaults = UserDefaults.standard
        
        if let savedFolders = userDefaults.object(forKey: "folders") as? Data {
            let decoder = JSONDecoder()
            
            do {
                folders = try decoder.decode([Folder].self, from: savedFolders)
                
            } catch let error {
                print("Error while loading folder data: \n\(error)")
            }
        }
    }

    func saveData() {
        let encoder = JSONEncoder()
        
        do {
            let folderData = try encoder.encode(folders)
            UserDefaults.standard.set(folderData, forKey: "folders")
            
        } catch let error {
            print("Error while loading folder data: \n\(error)")
        }
    }
    
    
    @objc func onNewFolderAlertTextInput(textField: UITextField) {
        newFolderSaveAction.isEnabled = textField.text != nil && textField.text!.isEmpty ? false : true
    }
    
    
    func makeNewFolderAlertController() -> UIAlertController {
        let alertController = UIAlertController(
            title: "New Folder",
            message: "Enter a name for this folder.",
            preferredStyle: .alert
        )
        
        alertController.addTextField(configurationHandler: { [unowned self] (textField: UITextField) in
            textField.placeholder = "Name"
            textField.addTarget(
                self,
                action: #selector(self.onNewFolderAlertTextInput),
                for: UIControl.Event.editingChanged
            )
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [unowned self, alertController] _ in
            let newFolderTitle = alertController.textFields![0].text!
            let newFolder = Folder(title: newFolderTitle, notes: [])
        
            self.folders.append(newFolder)
            self.saveData()
            self.tableView.reloadData()
        })
        
        saveAction.isEnabled = false  // disabled until some text is entered
        
        self.newFolderSaveAction = saveAction
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        return alertController
    }
    
    
    @IBAction func newFolderAdded(_ sender: Any) {
        let alertController = makeNewFolderAlertController()
        
        present(alertController, animated: true)
    }
}

