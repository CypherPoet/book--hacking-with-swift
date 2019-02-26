//
//  ViewController.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var columnButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    // MARK: - Event handling
    
    @IBAction func makeMove(_ sender: UIButton) {
    }
    
}

