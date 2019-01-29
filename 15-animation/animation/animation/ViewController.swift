//
//  ViewController.swift
//  animation
//
//  Created by Brian Sipple on 1/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

let sceneWidth = 1024
let sceneHeight = 768

class ViewController: UIViewController {
    @IBOutlet var triggerButton: UIButton!
    
    var currentAnimationIndex = 0
    var animationDuration = 1.0
    var animationDelay = 0.0
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = view.center
        imageView.layer.zPosition = 0
        
        view.addSubview(imageView)

        triggerButton.layer.zPosition = 1
    }
    

    @IBAction func triggerAnimation(_ sender: Any) {
        triggerButton.alpha = 0.0
        
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: { [unowned self] in
                self.runCurrentAnimation()
            },
            completion: { [unowned self] (finished: Bool) in
                self.triggerButton.alpha = 1.0
            }
        )
    
        currentAnimationIndex = (currentAnimationIndex + 1) % 8
    }
    
    
    func runCurrentAnimation() {
        switch currentAnimationIndex {
        case 0:
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 1:
            self.imageView.transform = CGAffineTransform.identity
        case 2:
            self.imageView.transform = CGAffineTransform(translationX: -(view.center.x / 2), y: -(view.center.y / 2))
        case 3:
            self.imageView.transform = CGAffineTransform.identity
        case 4:
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case 5:
            self.imageView.transform = CGAffineTransform.identity
        case 6:
            self.imageView.alpha = 0.1
            self.imageView.backgroundColor = UIColor.purple
        case 7:
            self.imageView.alpha = 1.0
            self.imageView.backgroundColor = UIColor.clear
        default:
            break
        }
    }
}

