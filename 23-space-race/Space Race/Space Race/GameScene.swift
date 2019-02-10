//
//  GameScene.swift
//  Space Race
//
//  Created by Brian Sipple on 2/9/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit

let sceneWidth = 1024.0
let sceneHeight = 768.0
let enemySpawnInterval = 0.333

enum EnemyType: String, CaseIterable {
    case ball, hammer, tv
}

let nodeNames = [
    "enemy": "enemy",
    "playerShip": "Normandy"
]


class GameScene: SKScene {
    var scoreLabel: SKLabelNode!
    var starfield: SKEmitterNode!
    var playerShip: SKSpriteNode!
    var gameTimer: Timer!
    
    var isGameOver = false {
        didSet {
            if isGameOver {
                gameTimer.invalidate()
            }
        }
    }
    
    var sceneCenter: CGPoint {
        return view!.center
    }
    
    var currentScore = 0 {
        didSet {
            self.scoreLabel.text = "Current score: \(currentScore)"
        }
    }
    
    var enemiesInSpace: [SKSpriteNode] {
        return children.filter { $0 is SKSpriteNode && $0.name == nodeNames["enemy"] } as! [SKSpriteNode]
    }
    
    var pastEnemies: [SKSpriteNode] {
        return enemiesInSpace.filter({ $0.position.x < $0.size.width * 3 })
    }
    
    var shipScreenBounds: (top: CGFloat, bottom: CGFloat) {
        return (CGFloat(sceneHeight) - playerShip.size.height, playerShip.size.height)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameOver {
            currentScore += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        var touchLocation = touch.location(in: self)
        
        if touchLocation.y > shipScreenBounds.top {
            touchLocation.y = shipScreenBounds.top
        } else if touchLocation.y < shipScreenBounds.bottom {
            touchLocation.y = shipScreenBounds.bottom
        }
        
        playerShip.position = touchLocation
    }
    
    override func didMove(to view: SKView) {
        setupUI()
        setupPhysics()
        startGame()
    }
    
    
    // MARK: UI
    func setupUI() {
        setupBackground()
        setupScoreLabel()
        setupPlayerShip()
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        
        addChild(scoreLabel)
        currentScore = 0
    }
    
    func setupPlayerShip() {
        playerShip = SKSpriteNode(imageNamed: "player")
        
        playerShip.position = CGPoint(x: 100.0, y: sceneCenter.y)
        playerShip.physicsBody = SKPhysicsBody(texture: playerShip.texture!, size: playerShip.size)
        playerShip.physicsBody?.contactTestBitMask = 1
        playerShip.name = nodeNames["playerShip"]
        
        addChild(playerShip)
    }
    
    func setupBackground() {
        self.backgroundColor = .black
        starfield = SKEmitterNode(fileNamed: "Starfield")!
        
        starfield.position = CGPoint(x: sceneWidth, y: Double(sceneCenter.y))
        starfield.zPosition = -1
        
        // cause the particles to spread out over our background
        starfield.advanceSimulationTime(10)
        
        addChild(starfield)
    }
    

    // MARK: Physics
    func setupPhysics() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    // MARK: Gameplay
    func startGame() {
        gameTimer = Timer.scheduledTimer(
            timeInterval: enemySpawnInterval,
            target: self,
            selector: #selector(spawnEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    

    @objc func spawnEnemy() {
        let enemyType = EnemyType.allCases.randomElement()!
        let enemy = SKSpriteNode(imageNamed: enemyType.rawValue)
        let enemyWidth = Double(enemy.size.width);
        let enemyHeight = Double(enemy.size.height);
        
        let xPos = sceneWidth + enemyWidth
        let yPos = Double.random(in: enemyHeight...(sceneHeight - enemyHeight))
        
        enemy.position = CGPoint(x: xPos, y: yPos)
        
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemy.physicsBody?.angularDamping = 0
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.angularVelocity = 5
        
        addChild(enemy)
    }
    
    func checkForPastEnemies() {
        pastEnemies.forEach({ remove(node: $0) })
    }
    
    func remove(node: SKNode) {
        node.removeFromParent()
    }
    
    func shipDestroyed(by enemy: SKNode) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        
        explosion.position = playerShip.position
        
        remove(node: enemy)
        remove(node: playerShip)
        addChild(explosion)
        
        isGameOver = true
    }
}


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if [nodeA.name, nodeB.name].contains(nodeNames["playerShip"]) {
            let collidingNode = nodeA.name == nodeNames["playerShip"] ? nodeB : nodeA
            
            shipDestroyed(by: collidingNode)
        }
        
    }
}
