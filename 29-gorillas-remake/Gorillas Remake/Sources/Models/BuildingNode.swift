//
//  BuildingNode.swift
//  Gorillas Remake
//
//  Created by Brian Sipple on 2/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import SpriteKit

let windowRowSpacing = 40

let buildingColorChoices = [
    UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1),
    UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1),
    UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1),
]

let litWindowColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
let darkWindowColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)

class BuildingNode: SKSpriteNode {
    lazy var renderer = UIGraphicsImageRenderer(size: size)
    
    var currentImage: UIImage! {
        didSet {
            texture = SKTexture(image: currentImage)
        }
    }
    
    func setup() {
        name = NodeNames.building.rawValue
        currentImage = draw(size: size)
        
        configurePhysics()
    }
    
    func draw(size: CGSize) -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            let buildingFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let buildingColor = buildingColorChoices.randomElement()!
            
            cgContext.setFillColor(buildingColor.cgColor)
            cgContext.addRect(buildingFrame)
            cgContext.drawPath(using: .fill)
            
            for windowRow in stride(from: 10, to: Int(size.height - 10), by: windowRowSpacing) {
                for column in stride(from: 10, to: Int(size.width - 10), by: windowRowSpacing) {
                    let windowColor = Bool.random() ? litWindowColor : darkWindowColor
                    
                    cgContext.setFillColor(windowColor.cgColor)
                    cgContext.fill(CGRect(x: column, y: windowRow, width: 15, height: 20))
                }
            }
        })
    }
    
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionBitMasks.building.rawValue
        physicsBody?.contactTestBitMask = CollisionBitMasks.banana.rawValue
    }
}
