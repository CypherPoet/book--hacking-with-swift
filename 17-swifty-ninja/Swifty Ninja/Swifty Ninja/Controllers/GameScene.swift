//
//  GameScene.swift
//  Swifty Ninja
//
//  Created by Brian Sipple on 1/31/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit

let sceneWidth = 1024.0
let sceneHeight = 768.0

class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var livesImageNodes = [SKSpriteNode]()
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    
    
    var remainingLives = 3
    
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    lazy var sceneCenterPoint = { () -> CGPoint in
        return CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)
    }()
    
    override func didMove(to view: SKView) {
        setupUI()
        setupPhysics()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    }
    
    
    func setupUI() {
        createBackground()
        createScoreLabel()
        createLivesImages()
        createSlicesMarks()
        
        currentScore = 0
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        
        background.position = sceneCenterPoint
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 8, y: 8)
        
        addChild(scoreLabel)
    }
    
    func createLivesImages() {
        let startX = sceneWidth - 190.0
        let distanceFromStartXs = 70
        
        for i in 0 ..< 3 {
            let lifeNode = SKSpriteNode(imageNamed: "sliceLife")
            
            lifeNode.position = CGPoint(x: (Double(i * distanceFromStartXs)) + startX, y: sceneHeight - 48)
            
            addChild(lifeNode)
            
            livesImageNodes.append(lifeNode)
        }
    }
    
    
    /**
     * Swiping around the screen will lead a glowing trail
     * of slice marks that fade away when the user lets go or keeps moving.
     */
    func createSlicesMarks() {
        activeSliceBG = SKShapeNode()
        activeSliceFG = SKShapeNode()
        
        activeSliceBG.zPosition = 2
        activeSliceFG.zPosition = 2
        
        activeSliceBG.strokeColor = UIColor(red: 1.0, green: 0.9, blue: 0, alpha: 1)
        activeSliceFG.strokeColor = UIColor.white
        
        activeSliceBG.lineWidth = 9
        activeSliceFG.lineWidth = 5
        
        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }
    
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
    }
    
}
