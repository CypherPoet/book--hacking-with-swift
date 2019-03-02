//
//  Move.swift
//  Four In A Row
//
//  Created by Brian Sipple on 3/1/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject {
    var value = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}


extension Move: GKGameModelUpdate {}
