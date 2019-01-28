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
    
    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        
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
}
