//
//  GameScene.swift
//  Swifty Ninja
//
//  Created by Brian Sipple on 1/31/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import AVFoundation

let sceneWidth = 1024.0
let sceneHeight = 768.0
let enemySize = 64.0

enum NextEnemy {
    case bomb
    case penguin
    case random
}

enum NodeName: String {
    case penguin = "penguin"
    case bomb = "bomb"
    case bombContainer = "bombContainer"
}


class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var sliceTrailBG: SKShapeNode!
    var sliceTrailFG: SKShapeNode!
    var currentBombSoundEffect: AVAudioPlayer?
    
    var isPlayingSwooshSound = false
    
    lazy var swooshSoundActions = [
        SKAction.playSoundFileNamed("swoosh1.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh2.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh3.caf", waitForCompletion: true)
    ]
    
    var lifeIndicators = [SKSpriteNode]()
    var sliceTrailPoints = [CGPoint]()
    var activeEnemies = [SKSpriteNode]()
    
    var remainingLives = 3
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    var hasBombsOnScreen: Bool {
        return activeEnemies.firstIndex(where: { $0.name == NodeName.bombContainer.rawValue }) != nil
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
    
    
    override func update(_ currentTime: TimeInterval) {
        if !hasBombsOnScreen {
            clearAnyBombSoundEffect()
        }
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
            
            lifeIndicators.append(lifeNode)
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
    
    
    /**
     * Things to consider:
     *
     *   1. Should this enemy be a penguin or a bomb?
     *       - Sometimes we'll want to force one or the other. For example, it wouldn't
     *         be fair to start off with a bomb as the very first target.
     *   2. Where should be it created on the screen?
     *   3. What direction should it be moving in?
     */
    func createEnemy(ofType enemyType: NextEnemy = .random) {
        var enemy: SKSpriteNode
        
        if enemyType == .bomb {
            enemy = makeBombNode()
            
        } else if enemyType == .penguin {
            enemy = makePenguinNode()
            
        } else {
            enemy = Int.random(in: 0...6) == 0 ? makeBombNode() : makePenguinNode()
        }
        
        configureInScene(enemy: enemy)
        activeEnemies.append(enemy)
        addChild(enemy)
    }
    
    
    func makePenguinNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "penguin")
        node.name = NodeName.penguin.rawValue
        
        return node
    }
    
    
    /**
     *  - Create a new SKSpriteNode that will hold the fuse and the bomb image as children, setting its Z position to be 1.
     *  - Create the bomb image, name it "bomb", and add it to the container.
     *  - If the bomb fuse sound effect is playing, stop it and destroy it.
     *  - Create a new bomb fuse sound effect, then play it.
     *  - Create a particle emitter node, position it so that it's at the end of the bomb image's fuse, and add it to the container.”
     */
    func makeBombNode() -> SKSpriteNode {
        let container = SKSpriteNode()
        let bomb = SKSpriteNode(imageNamed: "sliceBomb")
        let fuse = SKEmitterNode(fileNamed: "sliceFuse")!
        
        fuse.position = CGPoint(x: bomb.size.width + 12, y: bomb.size.height)
        
        container.zPosition = 1
        
        bomb.name = NodeName.bomb.rawValue
        container.name = NodeName.bombContainer.rawValue
        
        clearAnyBombSoundEffect()
        
        currentBombSoundEffect = makeBombSoundEffect()
        currentBombSoundEffect!.play()
        
        container.addChild(fuse)
        container.addChild(bomb)
        
        return container
    }
    
    func makeBombSoundEffect() -> AVAudioPlayer {
        let effectPath = Bundle.main.path(forResource: "sliceBombFuse.caf", ofType: nil)!
        let url = URL(fileURLWithPath: effectPath)
        
        let sound = try! AVAudioPlayer(contentsOf: url)
        
        return sound
    }
    
    
    func configureInScene(enemy: SKSpriteNode) {
        let yPosition = sceneHeight * -0.2
        let xPosition = Double.random(in: enemySize ... (sceneHeight - enemySize))
        
        let position = CGPoint(x: xPosition, y: yPosition)
        let angularVelocity = CGFloat.random(in: -6...6) / 2.0
        
        let yVelocity = Int.random(in: 24 ... 36)
        var xVelocity = 0
        
        if xPosition < sceneWidth * 0.25 || xPosition >= sceneWidth * 0.75 {
            xVelocity = Int.random(in: 8 ... 15)
        } else {
            xVelocity = Int.random(in: 3 ... 5)
        }
        
        enemy.position = position
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(enemySize))
        enemy.physicsBody!.velocity = CGVector(dx: xVelocity * 40, dy: yVelocity * 40)
        enemy.physicsBody!.angularVelocity = angularVelocity
        enemy.physicsBody!.collisionBitMask = 0
    }
    
    func clearAnyBombSoundEffect() {
        if currentBombSoundEffect != nil {
            currentBombSoundEffect!.stop()
            currentBombSoundEffect = nil
        }
    }
}
