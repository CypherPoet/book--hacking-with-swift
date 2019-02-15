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
    case player
}

let buildingSpacing = 2.0

let buildingMinHeight = sceneHeight * 0.30
let buildingMaxHeight = sceneHeight * 0.54


class GameScene: SKScene {
    lazy var sceneCenter = CGPoint(x: sceneWidth / 2.0, y: sceneHeight / 2.0)
    
    var buildings = [BuildingNode]()
    
    var buildingHeight: Double {
        return Double.random(in: buildingMinHeight...buildingMaxHeight)
    }
    
    var buildingWidth: Double {
        return Double(40 * Int.random(in: 2...4))
    }
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
    }
    
    
    func createBuildings() -> Void {
        var currentXPos = -15.0
        
        while currentXPos < sceneWidth {
            let width = buildingWidth
            let height = buildingHeight
            
            print("Current X: \(currentXPos), Current width: \(width)")
            
            let building = BuildingNode(color: UIColor.red, size: CGSize(width: width, height: height))
            
            building.position = CGPoint(x: currentXPos + (width / 2.0), y: height / 2.0)
            building.setup()
            
            addChild(building)
            buildings.append(building)
            
            currentXPos += (width + buildingSpacing)
        }
    }
}
