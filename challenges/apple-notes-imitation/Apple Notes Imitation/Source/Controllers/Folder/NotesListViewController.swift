//
//  FolderTableViewController.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class NotesListViewController: UITableViewController {
    var folder: Folder!
    
    var notes: [Note] {
        return folder.notes
    }
    
    var userDataKey: String {
        return "\(folder.title)::notes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        title = folder.title
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Item", for: indexPath) as! NoteTableViewCell

        cell.note = notes[indexPath.row]
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchNoteDetailView(with: notes[indexPath.row])
    }
    
    
    @IBAction func composeNote(_ sender: Any) {
        let newNote = Note(title: "New Note", body: "", lastUpdatedAt: Date())
        
        folder.notes.append(newNote)
        saveFolders()
        
        launchNoteDetailView(with: newNote)
    }
    
    
    func launchNoteDetailView(with note: Note) {
        if let noteDetailViewController = storyboard?.instantiateViewController(withIdentifier: "Note Detail") as? NoteDetailViewController {
            noteDetailViewController.note = note
            navigationController?.pushViewController(noteDetailViewController, animated: true)
        }
    }
    
    
    func saveFolders() {
        let userDefaults = UserDefaults.standard
        
        if let savedFolders = userDefaults.object(forKey: "folders") as? Data {
            let decoder = JSONDecoder()
            
            do {
                var folders = try decoder.decode([Folder].self, from: savedFolders)
                
                if let index = folders.firstIndex(where: { $0.title == folder.title }) {
                    folders[index] = folder
                
                    let encoder = JSONEncoder()
                    let folderData = try encoder.encode(folders)

                    UserDefaults.standard.set(folderData, forKey: "folders")
                }
                
            } catch let error {
                print("Error while loading folder data: \n\(error)")
            }
        }
    }
}
