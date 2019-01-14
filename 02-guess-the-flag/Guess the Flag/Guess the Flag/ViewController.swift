//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Brian Sipple on 1/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

let flagFilePathsAndNames = [
    "estonia": "Estonia",
    "france": "France",
    "germany": "Germany",
    "ireland": "Ireland",
    "italy": "Italy",
    "monaco": "Monaco",
    "nigeria": "Nigeria",
    "poland": "Poland",
    "russia": "Russia",
    "spain": "Spain",
    "uk": "United Kingdom",
    "us": "United States",
]


class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var currentScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupButtonStyles()
        askQuestion()
    }

    
    func askQuestion() {
        let flagKeys = flagFilePathsAndNames.keys.shuffled()[..<3]
        let flagToGuess = flagFilePathsAndNames[flagKeys.randomElement() ?? flagKeys[0]]

        if let _flagToGuess = flagToGuess {
            title = "Which flag belongs to \(_flagToGuess)"
        }
        
        for (index, button) in [button1, button2, button3].enumerated() {
            button?.setImage(UIImage(named: flagKeys[index]), for: .normal)
        }
    }
    
    
    func setupButtonStyles() {
        for button in [button1, button2, button3] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor(red: 1.00, green: 0.28, blue: 0.38, alpha: 1.00).cgColor
        }
    }
}

