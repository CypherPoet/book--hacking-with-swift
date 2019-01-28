//
//  GameScene.swift
//  Whack a Penguin
//
//  Created by Brian Sipple on 1/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit

let sceneWidth = 1024.0
let sceneHeight = 768.0

class GameScene: SKScene {
    var currentScoreLabel: SKLabelNode!
    var slots = [WhackSlot]()
    
    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        setupSlots()
        
        currentScore = 0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        
        background.position = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }
    
    
    func setupUI() {
        currentScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        currentScoreLabel.position = CGPoint(x: sceneWidth * 0.007, y: sceneHeight * 0.007)
        currentScoreLabel.horizontalAlignmentMode = .left
        currentScoreLabel.fontSize = 48
        
        addChild(currentScoreLabel)
    }
    
    func setupSlots() {
        let slotPositions = makeSlotPositions()
        
        for position in slotPositions {
            let whackSlot = WhackSlot()
            
            whackSlot.setup(at: position)
            addChild(whackSlot)
            slots.append(whackSlot)
        }
    }
    
    func makeSlotPositions() -> [CGPoint] {
        let holeWidth = 170.0
        let widerRowStartX = sceneWidth * 0.1
        let thinnerRowStartX = sceneWidth * 0.12
        let rowHeights = [0.534, 0.416, 0.298, 0.180].map({ $0 * sceneHeight })
        var positions = [CGPoint]()
        
        // row 1
        for i in 0..<5 { positions.append(CGPoint(x: widerRowStartX + (holeWidth * Double(i)), y: rowHeights[0])) }
        
        // row 2
        for i in 0..<4 { positions.append(CGPoint(x: thinnerRowStartX + (holeWidth * Double(i)), y: rowHeights[1])) }
        
        // row 3
        for i in 0..<5 { positions.append(CGPoint(x: widerRowStartX + (holeWidth * Double(i)), y: rowHeights[2])) }
        
        // row 4
        for i in 0..<4 { positions.append(CGPoint(x: thinnerRowStartX + (holeWidth * Double(i)), y: rowHeights[3])) }
        
        return positions
    }
}
