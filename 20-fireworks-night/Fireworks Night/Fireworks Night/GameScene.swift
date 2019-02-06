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


class GameScene: SKScene {
    let fireworkInterval = 6.0
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = sceneWidth + 22
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    
    var score = 0 {
        didSet {
            
        }
    }
    
    lazy var sceneCenterPoint = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupTimer()
    }
    
    func setupTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: fireworkInterval, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = sceneCenterPoint
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }


    @objc func launchFireworks() {
        
    }
}
