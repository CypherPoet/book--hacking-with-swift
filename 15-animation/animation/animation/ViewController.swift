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
    @IBOutlet weak var triggerButton: UIButton!
    
    var currentAnimation = 0
    var animationDuration = 1.0
    var animationDelay = 0.0
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = view.center
        
        view.addSubview(imageView)
    }
    

    @IBAction func triggerAnimation(_ sender: Any) {
        triggerButton.isHidden = true
        
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            options: [],
            animations: { [unowned self] in
                self.runCurrentAnimation()
            }
        ) { [unowned self] (finished: Bool) in
            self.triggerButton.isHidden = false
        }
    
        self.currentAnimation += 1 % 7
    }
    
    
    func runCurrentAnimation() {
        switch self.currentAnimation {
        case 0:
            break
            
        default:
            break
        }
    }
}

