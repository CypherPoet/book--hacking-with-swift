//
//  Player.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Player: NSObject {
    // MARK: - Static Properties
    
    static var allPlayers: [Player] = [Player(chipColor: .red), Player(chipColor: .black)]
    
    
    // MARK: - Instance Properties
    
    var chipColor: Board.ChipColor
    var name: String
    
    /// special propery for GameplayKit to identify each player uniquely
    var playerId: Int
    
    var uiColor: UIColor {
        switch chipColor {
        case .red:
            return #colorLiteral(red: 0.9146130681, green: 0, blue: 0.3108665347, alpha: 1)
        case .black:
            return #colorLiteral(red: 0.09483634681, green: 0.09486005455, blue: 0.09483323246, alpha: 1)
        case .none:
            return .lightGray
        }
    }
    
    var opponent: Player {
        return chipColor == .red ? Player.allPlayers[1] : Player.allPlayers[0]
    }

    
    // MARK: - Lifecycle
    
    init(chipColor: Board.ChipColor) {
        self.chipColor = chipColor
        self.name = chipColor == .red ? "Red" : "Black"
        self.playerId = chipColor.rawValue
        
        super.init()
    }
}
