//
//  GameScene.swift
//  Pachinko
//
//  Created by Brian Sipple on 1/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit

let sceneWidth = 1024
let sceneHeight = 768

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        createBackground()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
            
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
    
    
    func createBackground() {
        let backgroundNode = SKSpriteNode(imageNamed: "background.jpg")
        
        backgroundNode.position = CGPoint(x: sceneWidth/2, y: sceneHeight/2)
        backgroundNode.zPosition = -1
        backgroundNode.blendMode = .replace
        
        addChild(backgroundNode)
    }
}
