//
//  GameScene.swift
//  Pachinko
//
//  Created by Brian Sipple on 1/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit

let sceneWidth = 1024.0
let sceneHeight = 768.0

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        createBackground()
        placeObjects()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4
            ball.position = location
            
            addChild(ball)
        }
    }
    
    
    func createBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: "background.jpg")
        
        backgroundNode.position = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
        backgroundNode.zPosition = -1
        backgroundNode.blendMode = .replace
        
        addChild(backgroundNode)
    }
    
    func placeObjects() {
        let objectSpacing = sceneWidth / 4.0
        
        for i in 0..<5 {
            let bouncerPoint = CGPoint(x: objectSpacing * Double(i), y: 0.0)
            addChild(makeBouncer(at: bouncerPoint))
        }
        
        for i in 0..<4 {
            let slotBasePoint = CGPoint(x: 128 + (objectSpacing * Double(i)), y: 0.0)
            addChild(makeSlot(at: slotBasePoint, isGood: i % 2 == 0))
        }
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) -> SKSpriteNode {
        let slotFileName = isGood ? "slotBaseGood" : "slotBaseBad"
        let slotGlowFileName = isGood ? "slotGlowGood" : "slotGlowBad"
        
        let slotContainer = SKSpriteNode()
        let slotBase = SKSpriteNode(imageNamed: slotFileName)
        let slotGlow = SKSpriteNode(imageNamed: slotGlowFileName)
        
        let spinAction = SKAction.rotate(byAngle: .pi, duration: 10)
        let glowSpin = SKAction.repeatForever(spinAction)
        
        slotGlow.run(glowSpin)
        
        slotContainer.position = position
        slotContainer.addChild(slotBase)
        slotContainer.addChild(slotGlow)
        
        return slotContainer
    }
    
    
    func makeBouncer(at position: CGPoint) -> SKSpriteNode {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        
        return bouncer
    }
}
