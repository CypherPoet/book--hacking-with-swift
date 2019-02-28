//
//  Chip.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Chip: UIView {
    // MARK: - Properties
    var row: Int?
    var column: Int?
    var color: Board.ChipColor = .none
}
