//
//  ViewController.swift
//  Core Graphics
//
//  Created by Brian Sipple on 2/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

enum DrawType: String, CaseIterable {
    case rectangle
    case circle
    case checkerboard
    case rotatedSquares
    case spiralSquares
    case mouseScene
}

class HomeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let imageViewWidth = CGFloat(512)
    let imageViewHeight = CGFloat(512)

    lazy var renderer = UIGraphicsImageRenderer(size: CGSize(width: imageViewWidth, height: imageViewHeight))
    lazy var imageViewRect = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
    
    lazy var paragraphStyle = NSMutableParagraphStyle()
    lazy var fontAttrs = [
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 36)!,
        NSAttributedString.Key.paragraphStyle: paragraphStyle
    ]
    
    lazy var mouseImage = UIImage(named: "mouse")
    
    var currentDrawType = DrawType.rectangle
    
    var currentDrawFunction: () -> UIImage {
        return [
            .rectangle: drawRectangle,
            .circle: drawCircle,
            .checkerboard: drawCheckerboard,
            .rotatedSquares: drawRotatedSquares,
            .spiralSquares: drawSpiralSquares,
            .mouseScene: drawMouseScene,
        ][currentDrawType]!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.image = currentDrawFunction()
    }
    
    
    func drawRectangle() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(#colorLiteral(red: 0.9994066358, green: 0.3798269629, blue: 0.5379426479, alpha: 1))
            cgContext.setStrokeColor(#colorLiteral(red: 0.06273535639, green: 0.06275133044, blue: 0.06273186952, alpha: 1))
            cgContext.setLineWidth(10)
            
            cgContext.addRect(imageViewRect)
            cgContext.drawPath(using: .fillStroke)
        })
    }
    
    
    func drawCircle() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(#colorLiteral(red: 0.9994066358, green: 0.3798269629, blue: 0.5379426479, alpha: 1))
            cgContext.setStrokeColor(#colorLiteral(red: 0.06273535639, green: 0.06275133044, blue: 0.06273186952, alpha: 1))
            cgContext.setLineWidth(10)
            
            cgContext.addEllipse(in: imageViewRect)
            cgContext.drawPath(using: .fillStroke)
        })
    }
    
    
    func drawCheckerboard() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            let checkerSize = (imageViewWidth / 8.0)
            
            cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for column in 0 ..< 8 {
                    if (row % 2 == 0 && column % 2 == 1) || (row % 2 == 1 && column % 2 == 0) {
                        let xPos = CGFloat(row) * checkerSize
                        let yPos = CGFloat(column) * checkerSize
                    
                        cgContext.addRect(CGRect(x: xPos, y: yPos, width: checkerSize, height: checkerSize))
                    }
                }
            }
            
            cgContext.drawPath(using: .fillStroke)
        })
    }
    
    
    func drawRotatedSquares() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            let numRotations = 16
            
            let squareSize = imageViewWidth / 2.0
            let rotationAmount = Double.pi / Double(numRotations)
            
            cgContext.translateBy(x: imageViewWidth / 2.0, y: imageViewHeight / 2.0)
            
            for _ in 0 ..< numRotations {
                cgContext.rotate(by: CGFloat(rotationAmount))
                cgContext.addRect(CGRect(x: -squareSize / 2.0, y: -squareSize / 2.0, width: squareSize, height: squareSize))
            }
            
            cgContext.setStrokeColor(UIColor.black.cgColor)
            cgContext.strokePath()
        })
    }
    
    
    func drawSpiralSquares() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let cgContext = context.cgContext
            let numSquares = Int(imageViewWidth / 2)
            
            cgContext.translateBy(x: imageViewWidth / 2.0, y: imageViewHeight / 2.0)
            var currentLength = imageViewWidth / 2.0
            
            for i in 0 ..< numSquares {
                cgContext.rotate(by: CGFloat.pi / 2)
                
                if i == 0 {
                    cgContext.move(to: CGPoint(x: currentLength, y: 50))
                } else {
                    cgContext.addLine(to: CGPoint(x: currentLength, y: 50))
                }
                
                currentLength *= 0.99
            }
            
            cgContext.setStrokeColor(UIColor.black.cgColor)
            cgContext.strokePath()
        })
    }
    
    func drawMouseScene() -> UIImage {
        return renderer.image(actions: { (context: UIGraphicsImageRendererContext) in
            let string: NSString = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            paragraphStyle.alignment = .center
            
            string.draw(
                with: CGRect(x: 32, y: 32, width: imageViewWidth * 0.875, height: imageViewWidth * 0.875),
                options: .usesLineFragmentOrigin,
                attributes: fontAttrs,
                context: nil
            )
   
            mouseImage?.draw(at: CGPoint(x: imageViewWidth * 0.55, y: imageViewHeight * 0.30))
        })
    }
   
    
    @IBAction func redrawTapped(_ sender: Any) {
        let nextDrawTypeIndex = (DrawType.allCases.index(of: currentDrawType)! + 1) % DrawType.allCases.count
        
        currentDrawType = DrawType.allCases[nextDrawTypeIndex]
        imageView.image = currentDrawFunction()
    }
}

