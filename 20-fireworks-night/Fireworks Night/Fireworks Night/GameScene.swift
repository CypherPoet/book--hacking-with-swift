//
//  GameScene.swift
//  Fireworks Night
//
//  Created by Brian Sipple on 2/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit

let sceneWidth = 1024.0
let sceneHeight = 768.0

enum NodeName: String {
    case fireworkRocket = "Firework Rocket"
    case selectedFireworkRocket = "Firework Rocket (Selected)"
}

enum LaunchStyle: CaseIterable {
    case straightUp, fanUp, leftToRight, rightToLeft
}


class GameScene: SKScene {
    let fireworkInterval = 4.0
    let fireworkSpeed = 200.0
    let yThreshold = sceneHeight * 1.25
    let leftEdge = -22.0
    let bottomEdge = -22.0
    let rightEdge = sceneWidth + 22
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    var selectedRockets = [SKSpriteNode]()
    var scoreLabel: SKLabelNode!
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(currentScore)"
        }
    }
    
    var colorToDetonate: UIColor!
    lazy var rocketColors = [UIColor.cyan, UIColor.green, UIColor.red]
    
    lazy var sceneCenterPoint = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
    
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        setupTimer()
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        handleTouch(touch)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        cleanupPastFireworks()
    }
    
    
    func setupTimer() {
        gameTimer = Timer.scheduledTimer(
            timeInterval: fireworkInterval,
            target: self,
            selector: #selector(launchFireworks),
            userInfo: nil,
            repeats: true
        )
    }
    
    func setupUI() {
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: sceneWidth - 16, y: sceneHeight - 16)
        
        currentScore = 0
        addChild(scoreLabel)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = sceneCenterPoint
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }

    
    /**
     * Launch fireworks five at a time, in four different shapes
     */
    @objc func launchFireworks() {
        let burstQuantity = 5
        
        switch LaunchStyle.allCases.randomElement()! {
        case .straightUp:
            launchStraightUp(burstQuantity)
        case .fanUp:
            launchFanUp(burstQuantity)
        case .leftToRight:
            launchLeftToRight(burstQuantity)
        case .rightToLeft:
            launchRightToLeft(burstQuantity)
        }
    }
    
    
    func createLaunch(xMovement: Double, xPos: Double, yPos: Double) {
        let firework = makeFirework()
        let motion = makeFireworkMotion(xMovement: xMovement, speed: fireworkSpeed)
        
        firework.position = CGPoint(x: xPos, y: yPos)
        
        fireworks.append(firework)
        firework.run(motion)
        addChild(firework)
    }

    
    func makeFirework() -> SKNode {
        let firework = SKNode()
        let fireworkGlow = SKEmitterNode(fileNamed: "fuse")!
        let fireworkRocket = SKSpriteNode(imageNamed: "rocket")
        
        fireworkRocket.colorBlendFactor = 1
        fireworkRocket.name = NodeName.fireworkRocket.rawValue
        fireworkRocket.color = rocketColors.randomElement()!
        
        fireworkGlow.position = CGPoint(x: 0, y: -22)
        
        firework.addChild(fireworkGlow)
        firework.addChild(fireworkRocket)
        
        return firework
    }
    
    
    func makeFireworkMotion(xMovement: Double, speed: Double) -> SKAction {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: sceneHeight * 1.5))
        
        // `asOffset` makes the motion start relative to the node's position
        let motionPath = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: CGFloat(speed))
        
        return motionPath
    }
    
    
    func launchStraightUp(_ numFireworks: Int) {
        let spacingIncrement = (sceneHeight / Double(numFireworks)) / 2.0
        var currentSpacing = 0.0
        
        for n in 0 ..< numFireworks {
            currentSpacing = (n % 2 == 0) ? currentSpacing : currentSpacing + spacingIncrement
            let directionFromCenter = (n % 2 == 0) ? 1.0 : -1.0
            let xPosition = Double(sceneCenterPoint.x) + (currentSpacing * directionFromCenter)
                
            createLaunch(xMovement: 0, xPos: xPosition, yPos: bottomEdge)
        }
    }
    
    func launchFanUp(_ numFireworks: Int) {
        let spacingIncrement = (sceneHeight / Double(numFireworks)) / 2.0
        var currentSpacing = 0.0
        
        for n in 0 ..< numFireworks {
            currentSpacing = (n % 2 == 0) ? currentSpacing : currentSpacing + spacingIncrement
            let directionFromCenter = (n % 2 == 0) ? 1.0 : -1.0
            let xPosition = Double(sceneCenterPoint.x) + (currentSpacing * directionFromCenter)
            let xMovement = xPosition
            
            createLaunch(xMovement: xMovement, xPos: xPosition, yPos: bottomEdge)
        }
    }
    
    func launchLeftToRight(_ numFireworks: Int) {
        let spacingIncrement = (sceneHeight / Double(numFireworks)) / 2.0
        var currentSpacing = 0.0
        
        for n in 0 ..< numFireworks {
            currentSpacing = (n % 2 == 0) ? currentSpacing : currentSpacing + spacingIncrement
            let directionFromCenter = (n % 2 == 0) ? 1.0 : -1.0
            let yPosition = Double(sceneCenterPoint.y) + (currentSpacing * directionFromCenter)
            let xMovement = sceneWidth * 1.5

            createLaunch(xMovement: xMovement, xPos: leftEdge, yPos: yPosition)
        }
    }
    
    func launchRightToLeft(_ numFireworks: Int) {
        let spacingIncrement = (sceneHeight / Double(numFireworks)) / 2.0
        var currentSpacing = 0.0

        for n in 0 ..< numFireworks {
            currentSpacing = (n % 2 == 0) ? currentSpacing : currentSpacing + spacingIncrement
            let directionFromCenter = (n % 2 == 0) ? 1.0 : -1.0
            let yPosition = Double(sceneCenterPoint.y) + (currentSpacing * directionFromCenter)
            let xMovement = sceneWidth * 1.5
            
            createLaunch(xMovement: -xMovement, xPos: rightEdge, yPos: yPosition)
        }
    }

    
    func handleTouch(_ touch: UITouch) {
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            if node is SKSpriteNode && node.name == NodeName.fireworkRocket.rawValue {
                let rocketNode = node as! SKSpriteNode
                
                if !selectedRockets.isEmpty && rocketNode.color != colorToDetonate {
                    resetSelectedRockets()
                } else {
                    colorToDetonate = rocketNode.color
                    rocketNode.name = NodeName.selectedFireworkRocket.rawValue
                    rocketNode.colorBlendFactor = 0
                    rocketNode.color = UIColor.white
                    selectedRockets.append(rocketNode)
                }
            }
        }
    }
    
    
    func resetSelectedRockets() {
        for rocketNode in selectedRockets {
            rocketNode.name = NodeName.fireworkRocket.rawValue
            rocketNode.color = colorToDetonate
            rocketNode.colorBlendFactor = 1
        }
        
        selectedRockets.removeAll(keepingCapacity: true)
    }
    

    func cleanupPastFireworks() {
        for (index, firework) in fireworks.enumerated().reversed() {
            if Double(firework.position.y) > yThreshold {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    

    func explodeSelectedFireworks() {
        let pointsToAward = selectedRockets.count * 200
        
        selectedRockets.removeAll(keepingCapacity: true)
        
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.childNode(withName: NodeName.selectedFireworkRocket.rawValue) != nil {
                fireworks.remove(at: index)
                explode(firework: firework)
            }
        }
        
        currentScore += pointsToAward
    }


    func explode(firework: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "explode")!
        
        emitter.position = firework.position
        addChild(emitter)
        firework.removeFromParent()
    }
}
