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
    case player1
    case player2
}

let buildingSpacing = 2.0
let buildingMinHeight = sceneHeight * 0.21
let buildingMaxHeight = sceneHeight * 0.52

let throwSpeedMultipler = 0.25

let sceneTransitionDelay: TimeInterval = 2.0
let sceneTransitionDuration: TimeInterval = 1.5

class GameScene: SKScene {
    weak var gameViewController: GameViewController!
    lazy var sceneCenter = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
    
    var buildings = [BuildingNode]()
    lazy var banana = SKSpriteNode(imageNamed: "banana")
    lazy var player1 = SKSpriteNode(imageNamed: "player")
    lazy var player2 = SKSpriteNode(imageNamed: "player")
    
    lazy var player1ArmRaise = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
    lazy var player2ArmRaise = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
    
    lazy var sceneTransition = SKTransition.crossFade(withDuration: sceneTransitionDuration)

    var throwingAnimationSequence: SKAction {
        let armRaiseAction = currentPlayer == .playerOne ? player1ArmRaise : player2ArmRaise
        
        return SKAction.sequence([
            armRaiseAction,
            SKAction.wait(forDuration: 0.15),
            SKAction.setTexture(SKTexture(imageNamed: "player"))
        ])
    }
    
    var buildingHeight: Double {
        return Double.random(in: buildingMinHeight...buildingMaxHeight)
    }
    
    var buildingWidth: Double {
        return Double(40 * Int.random(in: 2...4))
    }
    
    var currentPlayer: CurrentPlayer {
        return gameViewController.currentPlayer
    }
    
    var currentPlayerNode: SKSpriteNode {
        return currentPlayer == .playerOne ? player1 : player2
    }
    
    var throwXDirectionWeight: Double {
        return currentPlayer == .playerOne ? 1.0 : -1.0
    }
    
    var bananaStartingPosition: CGPoint {
        switch currentPlayer {
        case .playerOne:
            return CGPoint(x: player1.position.x - 30.0, y: player1.position.y + 40.0)
        case .playerTwo:
            return CGPoint(x: player2.position.x + 30.0, y: player2.position.y + 40.0)
        }
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        handleBananaOffScene()
    }
    
    
    func createBuildings() -> Void {
        var currentXPos = -15.0
        
        while currentXPos < sceneWidth {
            let width = buildingWidth
            let height = buildingHeight
            
            let building = BuildingNode(color: UIColor.red, size: CGSize(width: width, height: height))
            
            building.position = CGPoint(x: currentXPos + (width / 2.0), y: height / 2.0)
            building.setup()
            
            addChild(building)
            buildings.append(building)
            
            currentXPos += (width + buildingSpacing)
        }
    }
    
    
    /**
     - Create player one and player two
        - Player 1 is atop the second building
        - Player 2 is atop the second-to-last building
     - Create a non-dynamic physics body for the players that collides with bananas
     */
    func createPlayers() {
        let leftBuilding = buildings[1]
        let rightBuilding = buildings[buildings.count - 2]
        
        player1.name = NodeNames.player1.rawValue
        player1.position = CGPoint(
            x: leftBuilding.position.x,
            y: leftBuilding.position.y + ((leftBuilding.size.height + player1.size.height) / 2)
        )
        
        player2.name = NodeNames.player2.rawValue
        player2.position = CGPoint(
            x: rightBuilding.position.x,
            y: rightBuilding.position.y + ((rightBuilding.size.height + player2.size.height) / 2)
        )
        
        for playerNode in [player1, player2] {
            playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
            playerNode.physicsBody?.categoryBitMask = CollisionBitMasks.player.rawValue
            playerNode.physicsBody?.collisionBitMask = CollisionBitMasks.banana.rawValue
            playerNode.physicsBody?.contactTestBitMask = CollisionBitMasks.banana.rawValue
            playerNode.physicsBody?.isDynamic = false
            
            addChild(playerNode)
        }
    }
    
    func addBananaToScene() {
        if self.intersects(banana) {
            banana.removeFromParent()
        }
        
        banana.position = bananaStartingPosition
        banana.name = NodeNames.banana.rawValue
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.height)
        
        banana.physicsBody?.categoryBitMask = CollisionBitMasks.banana.rawValue
        banana.physicsBody?.collisionBitMask = CollisionBitMasks.building.rawValue | CollisionBitMasks.player.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionBitMasks.building.rawValue | CollisionBitMasks.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        banana.physicsBody?.angularVelocity = CGFloat(20) * CGFloat(throwXDirectionWeight)

        addChild(banana)
    }

    /**
     - Determine how hard and in what direction to throw the banana
     - Remove any somehow-existing bananas
     - Animate the current player throwing the banana and sent it in motion
     */
    func launch(angle: Int, speed: Int) {
        currentPlayerNode.run(throwingAnimationSequence)
        throwBanana(angle: angle, speed: speed)
    }
    
    func throwBanana(angle degrees: Int, speed: Int) {
        let radians = radiansFromDegrees(Double(degrees))
        let speedMagnitude = Double(speed) * throwSpeedMultipler
        
        let xMomentum = cos(radians) * speedMagnitude * throwXDirectionWeight
        let yMomentum = sin(radians) * speedMagnitude
        
        let velocity = CGVector(dx: xMomentum, dy: yMomentum)
        
        addBananaToScene()
        banana.physicsBody?.applyImpulse(velocity)
    }
    
    /**
     If a banana hits a player, it means they have lost the game.
     The hit player will also explode 🙂
     */
    func destroy(player: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "hitPlayer")!
        
        explosion.position = player.position
        player.removeFromParent()
        banana.removeFromParent()
        
        transitionToNewScene()
    }
    
    func bananaHit(building buildingNode: BuildingNode) {
        let buildingLocation = convert(banana.position, to: buildingNode)
        let explosion = SKEmitterNode(fileNamed: "hitBuilding")!
        
        explosion.position = banana.position

        addChild(explosion)
        
        // account for the banana potentially hitting two buildings at the same time by making sure the second hit
        // won't be detected in `didBegin`
        banana.name = ""
        
        buildingNode.hitAt(point: buildingLocation)
    }
    
    func launchCompleted() {
        banana.removeFromParent()
        gameViewController.launchCompleted()
    }

    
    func transitionToNewScene() {
        DispatchQueue.main.asyncAfter(deadline: .now() + sceneTransitionDelay) { [unowned self] in
            let newScene = GameScene(size: self.size)

            newScene.gameViewController = self.gameViewController
            self.view?.presentScene(newScene, transition: self.sceneTransition)
            
            self.gameViewController.changeCurrentPlayer()
        }
    }
    
    func handleBananaOffScene() {
        guard gameViewController.gameplayState == .throwing else { return }
        guard let firstBuilding = buildings.first else { return }
        guard let lastBuilding = buildings.last else { return }
        
        if (
            banana.position.x > lastBuilding.position.x + lastBuilding.size.width ||
            banana.position.x < firstBuilding.position.x
        ) {
            launchCompleted()
        }
    }
    
    
    func radiansFromDegrees(_ degrees: Double) -> Double {
        return (degrees / 180.0) * Double.pi
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    /**
     Possible contacts to handle:
        - banana hit building
        - building hit banana
        - banana hit player 1
        - player 1 hit banana
        - banana hit player 2
        - player 2 hit banana
     */
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node as? SKSpriteNode else { return }
        guard let nodeB = contact.bodyB.node as? SKSpriteNode else { return }
        
        let nodes = [nodeA, nodeB]
        
        if [nodeA.name, nodeB.name].contains(NodeNames.banana.rawValue) {
            let otherNode = nodes.first(where: { $0.name != NodeNames.banana.rawValue })!
            
            if otherNode.name == NodeNames.player1.rawValue {
                destroy(player: player1)
            } else if nodeB.name == NodeNames.player2.rawValue {
                destroy(player: player2)
            } else if otherNode.name == NodeNames.building.rawValue {
                bananaHit(building: otherNode as! BuildingNode)
            }
        }
    }
}
