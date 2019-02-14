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
}

class HomeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    lazy var imageViewRect = CGRect(x: 0, y: 0, width: 512, height: 512)
    
    var currentDrawType = DrawType.rectangle
    
    var currentDrawFunction: () -> UIImage {
        return [
            .rectangle: drawRectangle,
            .circle: drawCircle
        ][currentDrawType]!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.image = currentDrawFunction()
    }
    
    
    func drawRectangle() -> UIImage {
        return renderer.image(actions: { context in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(#colorLiteral(red: 0.9994066358, green: 0.3798269629, blue: 0.5379426479, alpha: 1))
            cgContext.setStrokeColor(#colorLiteral(red: 0.06273535639, green: 0.06275133044, blue: 0.06273186952, alpha: 1))
            cgContext.setLineWidth(10)
            
            cgContext.addRect(imageViewRect)
            cgContext.drawPath(using: .fillStroke)
        })
    }
    
    
    func drawCircle() -> UIImage {
        return renderer.image(actions: { context in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(#colorLiteral(red: 0.9994066358, green: 0.3798269629, blue: 0.5379426479, alpha: 1))
            cgContext.setStrokeColor(#colorLiteral(red: 0.06273535639, green: 0.06275133044, blue: 0.06273186952, alpha: 1))
            cgContext.setLineWidth(10)
            
            cgContext.addEllipse(in: imageViewRect)
            cgContext.drawPath(using: .fillStroke)
        })
    }

    @IBAction func redrawTapped(_ sender: Any) {
        let nextDrawTypeIndex = (DrawType.allCases.index(of: currentDrawType)! + 1) % DrawType.allCases.count
        
        currentDrawType = DrawType.allCases[nextDrawTypeIndex]
        imageView.image = currentDrawFunction()
    }
}

