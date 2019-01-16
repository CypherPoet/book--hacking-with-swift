//
//  FlagTableViewCell.swift
//  World Flag Sharing
//
//  Created by Brian Sipple on 1/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var flagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
