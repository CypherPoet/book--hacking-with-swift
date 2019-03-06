//
//  GradientView.swift
//  ESP Tester
//
//  Created by Brian Sipple on 3/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    // MARK: - Instance Properties
    
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    
    // MARK: - Computed Properties
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
