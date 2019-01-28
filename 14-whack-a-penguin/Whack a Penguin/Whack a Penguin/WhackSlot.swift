//
//  WhackSlot.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 1/28/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var penguinNode: SKSpriteNode!
    
    func setup(at position: CGPoint) {
        self.position = position
        
        let hole = SKSpriteNode(imageNamed: "whackHole")
        
        setupPenguin(at: position)
        self.addChild(hole)
    }
    
    
    private func setupPenguin(at position: CGPoint) {
        let cropNode = SKCropNode()
        penguinNode = SKSpriteNode(imageNamed: "penguinGood")
        
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        penguinNode.position = CGPoint(x: 0, y: -90)
        penguinNode.name = "penguin"
        
        cropNode.addChild(penguinNode)
        
        self.addChild(cropNode)
        
        
    }
}
