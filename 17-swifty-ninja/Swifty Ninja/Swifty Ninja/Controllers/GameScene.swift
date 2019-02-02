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
let startingLives = 3

enum EnemySequence: CaseIterable {
    case onePenguin
    case oneRandom
    case onePenguinOneBomb
    case twoRandoms
    case threeRandoms
    case fourRandoms
    case chain
    case fastChain
}

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
    var enemyRespawnInterval = 0.9
    var enemySequenceQueue: [EnemySequence]!
    var enemySequencePosition = 0
    var isNextEnemySequenceQueued = false
    
    /**
     * Enemy chains don't wait until the previous enemy is offscreen before
     * creating a new one. Instead, they'll spawn multiple enemies
     * quickly, but with a small delay between each one.
     */
    var enemyChainInterval = 3.0
    
    lazy var swooshSoundActions = [
        SKAction.playSoundFileNamed("swoosh1.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh2.caf", waitForCompletion: true),
        SKAction.playSoundFileNamed("swoosh3.caf", waitForCompletion: true)
    ]
    
    // Make the enemy scale out and fade out at the same time, then remove it from the parent node
    lazy var destroyEnemyActionSequence = SKAction.sequence([
        SKAction.group([
            SKAction.scale(to: 0.001, duration: 0.2),
            SKAction.fadeOut(withDuration: 0.2)
        ]),
        SKAction.removeFromParent()
    ])
    
    lazy var destroyPenguinSoundAction = SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false)
    lazy var destroyBombSoundAction = SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false)
    lazy var lostLifeSoundAction = SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false)
    lazy var expiredLifeTexture = SKTexture(imageNamed: "sliceLifeGone")
    
    
    var lifeIndicators = [SKSpriteNode]()
    var sliceTrailPoints = [CGPoint]()
    var activeEnemies = [SKSpriteNode]()
    
    var remainingLives = startingLives
    var hasGameEnded = false
    
    var previousLifeImageSlot: SKSpriteNode {
        let index = startingLives - remainingLives - 1
        
        return lifeIndicators[index]
    }
    
    let startingEnemyYPosition = sceneHeight * -0.2
    
    // If an enemy falls past this point, the player looses a life
    var enemyFalloffThreshold: Double {
        return startingEnemyYPosition - enemySize
    }
    
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
        startSpawningEnemies()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sliceTrailPoints.removeAll(keepingCapacity: true)
        
        guard let touch = touches.first else { return }
        
        beginDrawingSlices(afterTouch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !hasGameEnded else { return }
        guard let touch = touches.first else { return }
        
        let touchPoint = touch.location(in: self)
        
        expandSliceTrails(to: touchPoint)
        detectHitsOnTouchesMoved(to: touchPoint)
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
        
        if activeEnemies.count > 0 {
            clearPassedEnemies()
        } else if !isNextEnemySequenceQueued {
            DispatchQueue.main.asyncAfter(deadline: .now() + enemyRespawnInterval) { [unowned self] in
                self.spawnEnemies()
            }

            isNextEnemySequenceQueued = true
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
        
        fuse.position = CGPoint(x: (bomb.size.width / 2) + 12, y: bomb.size.height / 2)
        
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
        let xPosition = Double.random(in: enemySize ... (sceneHeight - enemySize))
        
        let position = CGPoint(x: xPosition, y: startingEnemyYPosition)
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
    
    /**
     * 📝 We're going to decrease both `enemyRespawnInterval` and `enemyChainInterval` so that the game gets harder.
     * Sneakily, we're always going to increase the speed of our physics world,
     * so that objects move, rise, and fall faster, too
     */
    func spawnEnemies() {
        guard !hasGameEnded else { return }

        enemyRespawnInterval *= 0.991
        enemyChainInterval *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = enemySequenceQueue[enemySequencePosition]
        
        switch sequenceType {
        case .onePenguin:
            createEnemy(ofType: .penguin)
        case .oneRandom:
            createEnemy(ofType: .random)
        case .onePenguinOneBomb:
            createEnemy(ofType: .penguin)
            createEnemy(ofType: .bomb)
        case .twoRandoms:
            for _ in 0...1 { createEnemy(ofType: .random) }
        case .threeRandoms:
            for _ in 0...2 { createEnemy(ofType: .random) }
        case .fourRandoms:
            for _ in 0...3 { createEnemy(ofType: .random) }
        case .chain:
            let now = DispatchTime.now()
            
            createEnemy(ofType: .random)
            
            for deadline in [
                now + enemyChainInterval * 0.2,
                now + enemyChainInterval * 0.4,
                now + enemyChainInterval * 0.6,
                now + enemyChainInterval * 0.8
            ] {
                DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
                    self.createEnemy(ofType: .random)
                }
            }
        case .fastChain:
            let now = DispatchTime.now()
            
            createEnemy(ofType: .random)
            
            for deadline in [
                now + enemyChainInterval * 0.1,
                now + enemyChainInterval * 0.2,
                now + enemyChainInterval * 0.3,
                now + enemyChainInterval * 0.4
            ] {
                DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
                    self.createEnemy(ofType: .random)
                }
            }
        }
        
        enemySequencePosition += 1
        isNextEnemySequenceQueued = false
    }
    
    
    func startSpawningEnemies() {
        enemySequenceQueue = [
            .onePenguin,
            .onePenguin,
            .onePenguinOneBomb,
            .onePenguinOneBomb,
            .threeRandoms,
            .oneRandom,
            .chain
        ]
        
        for _ in 0...1000 {
            enemySequenceQueue.append(EnemySequence.allCases.randomElement()!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.spawnEnemies()
        }
    }
    
    func clearPassedEnemies() {
        for node in activeEnemies {
            if Double(node.position.y) < enemyFalloffThreshold {
                if let index = activeEnemies.index(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                if node.name == NodeName.penguin.rawValue {
                    subtractLife()
                }
                
                node.removeAllActions()
                node.name = ""
            }
        }
    }
    
    func expandSliceTrails(to location: CGPoint) {
        sliceTrailPoints.append(location)
        redrawSliceTrails()
        
        if !isPlayingSwooshSound {
            playSwooshSound()
        }
    }
    
    
    func detectHitsOnTouchesMoved(to location: CGPoint) {
        let nodesAtTouchPoint = nodes(at: location)
        
        for node in nodesAtTouchPoint {
            if node.name == NodeName.bomb.rawValue {
                destroy(bomb: node)
            } else if node.name == NodeName.penguin.rawValue {
                destroy(penguin: node)
                currentScore += 1
            }
        }
    }
    
    /**
     * - Create a particle effect over the penguin.
     * - Clear its node name so that it can't be swiped repeatedly.
     * - Disable the isDynamic of its physics body so that it doesn't carry on falling.
     * - Run a group of destruction animation actions and then remove the penguin from the scene.
     * - Remove the enemy from our activeEnemies array.
     * - Play a sound so the player knows they hit the penguin.
     */
    func destroy(penguin penguinNode: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy")!
        
        emitter.position = penguinNode.position
        addChild(emitter)
        
        penguinNode.name = ""
        penguinNode.physicsBody?.isDynamic = false
        
        penguinNode.run(destroyEnemyActionSequence)
        
        if let enemyIndex = activeEnemies.index(of: penguinNode as! SKSpriteNode) {
            activeEnemies.remove(at: enemyIndex)
            run(destroyPenguinSoundAction)
        }
    }
    
    
    /**
     *  - The node called "bomb" is the bomb image, which is inside the bomb container.
     *    So, we need to reference the node's parent when looking up our position,
     *    changing the physics body, removing the node from the scene,
     *    and removing the node from our activeEnemies array.
     *
     *  - create a different particle effect for bombs than for penguins.
     *  - end by calling the (as yet unwritten) method endGame()
     *
     */
    func destroy(bomb bombNode: SKNode) {
        let bombContainer = bombNode.parent! as! SKSpriteNode
        
        guard bombContainer.name == NodeName.bombContainer.rawValue else {
            fatalError("Couldn't find bombContainer from what was supposed to be a bomb node")
        }

        let emitter = SKEmitterNode(fileNamed: "sliceHitBomb")!
        
        emitter.position = bombContainer.position
        addChild(emitter)
        
        bombNode.name = ""
        bombContainer.name = ""
        bombContainer.physicsBody?.isDynamic = false
        bombContainer.run(destroyEnemyActionSequence)
        
        if let index = activeEnemies.index(of: bombContainer) {
            activeEnemies.remove(at: index)
            run(destroyBombSoundAction)
        }
        
        endGame(triggeredByBomb: true)
    }
    
    
    func subtractLife() {
        guard !hasGameEnded else { return }

        remainingLives -= 1
        
        let lifeImageSlot = previousLifeImageSlot
        
        lifeImageSlot.texture = expiredLifeTexture
        lifeImageSlot.xScale = 1.3
        lifeImageSlot.yScale = 1.3
        lifeImageSlot.run(SKAction.scale(to: 1, duration: 0.1))
        run(lostLifeSoundAction)
        
        if remainingLives == 0 {
            endGame(triggeredByBomb: false)
        }
    }
    
    
    func endGame(triggeredByBomb: Bool) {
        guard !hasGameEnded else { return }
        
        hasGameEnded = true
        isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.physicsWorld.speed = 0
            
            if self.currentBombSoundEffect != nil {
                self.currentBombSoundEffect!.stop()
                self.currentBombSoundEffect = nil
            }
        }
        
        if triggeredByBomb {
            for lifeIndicaor in lifeIndicators {
                lifeIndicaor.texture = expiredLifeTexture
            }
        }
    }
}
