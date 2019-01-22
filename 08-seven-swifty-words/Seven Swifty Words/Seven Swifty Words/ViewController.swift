//
//  ViewController.swift
//  Seven Swifty Words
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    @IBAction func submitTapped(_ sender: Any) {
    }
    
    
    @IBAction func clearTapped(_ sender: Any) {
    }
}

