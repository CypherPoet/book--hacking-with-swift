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
    var sliceTrailBG: SKShapeNode!
    var sliceTrailFG: SKShapeNode!
    
    var isPlayingSwooshSound = false
    
    lazy var swooshSoundActions = [
        SKAction.playSoundFileNamed("swoosh1.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh2.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh3.caf", waitForCompletion: true)
    ]
    
    var livesImageNodes = [SKSpriteNode]()
    var sliceTrailPoints = [CGPoint]()
    
    var remainingLives = 3
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    lazy var sceneCenterPoint = { () -> CGPoint in
        return CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)
    }()
    
    var drawableSliceTrailPath: CGPath {
        let path = UIBezierPath()
        
        if let startPoint = sliceTrailPoints.first {
            path.move(to: startPoint)
        }
        
        for index in 1 ..< sliceTrailPoints.count {
            path.addLine(to: sliceTrailPoints[index])
        }
        
        return path.cgPath
    }
    
    
    override func didMove(to view: SKView) {
        setupUI()
        setupPhysics()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sliceTrailPoints.removeAll(keepingCapacity: true)
        
        guard let touch = touches.first else { return }
        
        beginDrawingSlices(afterTouch: touch)
    }
    
    /**
     *
     */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        sliceTrailPoints.append(touch.location(in: self))
        redrawSliceTrails()
        
        if !isPlayingSwooshSound {
            playSwooshSound()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fadeOutSliceTrails()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    
    func setupUI() {
        createBackground()
        createScoreLabel()
        createLivesImages()
        createSlicesTrails()
        
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
    func createSlicesTrails() {
        sliceTrailBG = SKShapeNode()
        sliceTrailFG = SKShapeNode()
        
        sliceTrailBG.zPosition = 2
        sliceTrailFG.zPosition = 2
        
        sliceTrailBG.strokeColor = UIColor(red: 1.0, green: 0.9, blue: 0, alpha: 1)
        sliceTrailFG.strokeColor = UIColor.white
        
        sliceTrailBG.lineWidth = 9
        sliceTrailFG.lineWidth = 5
        
        addChild(sliceTrailBG)
        addChild(sliceTrailFG)
    }
    
    
    func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
    }
    
    
    /**
     * - If we have fewer than two points in our array, we don't have enough
     *   data to draw a line so it needs to clear the shapes and exit the method
     *
     * - If we have more than 12 slice points in our array, we need to remove the
     *   oldest ones until we have at most 12. This stops the swipe shapes from becoming too long
     */
    func redrawSliceTrails() {
        guard sliceTrailPoints.count > 2 else {
            sliceTrailBG.path = nil
            sliceTrailFG.path = nil
            return
        }
        
        if (sliceTrailPoints.count > 12) {
            sliceTrailPoints.removeFirst(sliceTrailPoints.count - 12)
        }
        
        sliceTrailBG.path = drawableSliceTrailPath
        sliceTrailFG.path = drawableSliceTrailPath
    }
    
    
    func fadeOutSliceTrails() {
        sliceTrailBG.run(SKAction.fadeOut(withDuration: 0.25))
        sliceTrailFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    
    func beginDrawingSlices(afterTouch touch: UITouch) {
        sliceTrailPoints.removeAll(keepingCapacity: true)
        sliceTrailPoints.append(touch.location(in: self))
        
        redrawSliceTrails()
        
        // remove any actions that are currently associated with our slice trails
        // and set their alpha to 1
        sliceTrailBG.removeAllActions()
        sliceTrailFG.removeAllActions()
        
        sliceTrailBG.alpha = 1
        sliceTrailFG.alpha = 1
    }
    
    
    func playSwooshSound() {
        let soundAction = swooshSoundActions.randomElement()!
        
        isPlayingSwooshSound = true
        
        run(soundAction) { [unowned self] in
            self.isPlayingSwooshSound = false
        }
    }
}
