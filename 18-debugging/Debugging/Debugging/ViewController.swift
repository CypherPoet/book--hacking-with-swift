//
//  ViewController.swift
//  Debugging
//
//  Created by Brian Sipple on 2/2/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        generateNumbers()
    }


    func generateNumbers() {
        for i in 1...100 {
            print("You're number \(i)!")
            if i == 88 {
//                fatalError("Very unlucky number: \(i)")
            }
        }
    }
    
}

