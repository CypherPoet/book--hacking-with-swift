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
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
        
        player.zPosition = 10
        player.position = CGPoint(x: frame.width * 0.16667, y: frame.height * 0.75)
        
        player.run(SKAction.repeatForever(propellerAnimation))
        
        return player
    }
}
