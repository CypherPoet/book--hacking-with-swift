//
//  NoteTableViewCell.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var lastUpdatedAtLabel: UILabel!
    @IBOutlet weak var contentPreviewLabel: UILabel!
    
    
    var note: Note! {
        didSet {
            noteTitleLabel.text = note.title
            lastUpdatedAtLabel.text = note.lastUpdatedAt?.description
            contentPreviewLabel.text = note.body
        }
    }

}
