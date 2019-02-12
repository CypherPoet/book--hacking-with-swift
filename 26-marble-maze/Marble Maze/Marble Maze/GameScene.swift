//
//  GameScene.swift
//  Marble Maze
//
//  Created by Brian Sipple on 2/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import SpriteKit
import GameplayKit

let sceneWidth = 1024.0
let sceneHeight = 768.0
let cellSize = 64.0

enum CellType: String, CaseIterable {
    case space
    case wall
    case vortex
    case star
    case finish
}

let cellTypes: [String: CellType] = [
    " ": .space,
    "x": .wall,
    "v": .vortex,
    "s": .star,
    "f": .finish
]


enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
}


class GameScene: SKScene {
    lazy var sceneCenterPoint = CGPoint(x: sceneWidth / 2, y: sceneHeight / 2)
    lazy var vortexSpinAction = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1))

    
    override func didMove(to view: SKView) {
        loadLevel(filename: "level1")
        setupBackground()
    }
    
    
    func loadLevel(filename: String) {
        guard let levelPath = Bundle.main.path(forResource: filename, ofType: "txt") else {
            print("Failed to load level data for filename \"\(filename).txt\"")
            return
        }
        
        if let levelMap = try? String(contentsOfFile: levelPath) {
            let lines = levelMap.components(separatedBy: "\n")
            
            for (row, line) in lines.reversed().enumerated() {
                for (column, letter) in line.enumerated() {
                    let xPosition = (cellSize * Double(column)) + (cellSize / 2)
                    let yPosition = (cellSize * Double(row)) + (cellSize / 2)
                    
                    let position = CGPoint(x: xPosition, y: yPosition)
                    
                    var node: SKNode
                    
                    if let cellType = cellTypes[String(letter)] {
                        switch cellType {
                        case .space:
                            continue
                        case .wall:
                            node = loadWallCell()
                        case .vortex:
                            node = loadVortexCell()
                        case .star:
                            node = loadStarCelll()
                        case .finish:
                            node = loadFinishCell()
                        }
                        
                        node.position = position
                        addChild(node)
                    } else {
                        print("Unkown cell type: \"\(String(letter))\"")
                    }
                }
            }
            
        } else {
            print("Failed to load level map from file at \"\(levelPath)\"")
        }
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        
        background.position = sceneCenterPoint
        background.zPosition = -1
        background.blendMode = .replace
        
        addChild(background)
    }

    func loadWallCell() -> SKNode {
        let node = SKSpriteNode(imageNamed: "block")
        
        node.name = CellType.wall.rawValue
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        
        return node
    }
    
    func loadVortexCell() -> SKNode {
        let node = SKSpriteNode(imageNamed: "vortex")
        
        node.name = CellType.vortex.rawValue
        node.run(vortexSpinAction)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func loadStarCelll() -> SKNode {
        let node = SKSpriteNode(imageNamed: "star")
        
        node.name = CellType.star.rawValue
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
    
    func loadFinishCell() -> SKNode {
        let node = SKSpriteNode(imageNamed: "finish")
        
        node.name = CellType.finish.rawValue
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        return node
    }
}

