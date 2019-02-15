//
//  GameScene.swift
//  Gorillas Remake
//
//  Created by Brian Sipple on 2/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit

let sceneWidth = 1024.0
let sceneHeight = 768.0

enum CollisionBitMasks: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

enum NodeNames: String {
    case banana
    case building
    case player
}


class GameScene: SKScene {
    lazy var sceneCenter = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
    
    
    override func didMove(to view: SKView) {
        setupBackground()
    }
    
    
    func setupBackground() -> Void {
        
    }
}
