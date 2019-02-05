//
//  FolderTableViewCell.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    @IBOutlet weak var noteCountLabel: UILabel!
    

    var folder: Folder! {
        didSet {
            self.textLabel?.text = folder.title
            self.noteCountLabel.text = String(folder.notes.count)
        }
    }
    
}
