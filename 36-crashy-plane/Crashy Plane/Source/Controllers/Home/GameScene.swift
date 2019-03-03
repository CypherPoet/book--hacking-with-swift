//
//  GameScene.swift
//  Crashy Plane
//
//  Created by Brian Sipple on 3/2/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    enum SceneParam {
        static let width = 750.0
        static let height = 1334.0
    }
    
    
    // MARK: - Instance Properties
    
    lazy var player = makePlayer()
    
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        addChild(player)
        createSky()
        createBackground()
        createGround()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    // MARK: - Methods
    
    func createSky() {
        let topSky = SKSpriteNode(color: SceneColor.topSky, size: CGSize(width: frame.width, height: frame.height * 0.67))
        let bottomSky = SKSpriteNode(color: SceneColor.bottomSky, size: CGSize(width: frame.width, height: frame.height * 0.33))
        
        [topSky, bottomSky].forEach { (node) in
            node.anchorPoint = CGPoint(x: 0.5, y: 1)
            node.position = CGPoint(x: frame.midX, y: frame.height)
            node.zPosition = ZPosition.sky
            
            addChild(node)
        }
    }
    
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background")
        let backgroundSize = backgroundTexture.size()
        
        let slideSequence = SKAction.sequence([
            SKAction.moveBy(x: -backgroundSize.width, y: 0, duration: 20),
            SKAction.moveBy(x: backgroundSize.width, y: 0, duration: 0)
        ])
        
        for i in 0...1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            let xPos = (CGFloat(i) * backgroundTexture.size().width) - CGFloat(1 * i) // small overlap for second piece
            
            background.anchorPoint = CGPoint.zero
            background.zPosition = ZPosition.slidingBackground
            background.position = CGPoint(x: xPos, y: 10)
            
            background.run(SKAction.repeatForever(slideSequence))
            
            addChild(background)
        }
    }
    
    
    func createGround() {
        let groundTexture = SKTexture(imageNamed: "ground")
        let groundSize = groundTexture.size()
        
        let slideSequence = SKAction.sequence([
            SKAction.moveBy(x: -groundSize.width, y: 0, duration: 5),
            SKAction.moveBy(x: groundSize.width, y: 0, duration: 0)
        ])
        
        for i in 0...1 {
            let xPos = (groundSize.width / 2) + (CGFloat(i) * groundSize.width)
            let yPos = groundSize.height / 2
            let ground = SKSpriteNode(texture: groundTexture)
            
            ground.position = CGPoint(x: xPos, y: yPos)
            ground.zPosition = ZPosition.ground
            ground.run(SKAction.repeatForever(slideSequence))
            
            addChild(ground)
        }
    }
    
    
    
    // MARK: - Private functions
    
    /**
     Create the player node, starting from the first-phase animation sprite
     and positioning it most of the way up and most of the way to the left of
     the screen.
     
     We'll also configure it to animate through each propeller phase as fast as possible
     */
    private func makePlayer() -> SKSpriteNode {
        let texture1 = SKTexture(imageNamed: "player-1")
        let texture2 = SKTexture(imageNamed: "player-2")
        let texture3 = SKTexture(imageNamed: "player-3")

        let player = SKSpriteNode(texture: texture1)
        let propellerAnimation = SKAction.animate(with: [texture1, texture2, texture3, texture2], timePerFrame: 0.01)
        
        player.zPosition = ZPosition.player
        player.position = CGPoint(x: frame.width * 0.16667, y: frame.height * 0.75)
        
        player.run(SKAction.repeatForever(propellerAnimation))
        
        return player
    }
}
