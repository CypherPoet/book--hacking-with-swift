//
//  ViewController.swift
//  Guess the Flag
//
//  Created by Brian Sipple on 1/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

let flagFileNames = [
    "estonia",
    "france",
    "germany",
    "ireland",
    "italy",
    "monaco",
    "nigeria",
    "poland",
    "russia",
    "spain",
    "uk",
    "us"
]

enum Country: String {
    case estonia = "Estonia"
    case france = "France"
    case germany = "Germany"
    case ireland = "Ireland"
    case italy = "Italy"
    case monaco = "Monaco"
    case nigeria = "Nigeria"
    case poland = "Poland"
    case russia = "Russia"
    case spain = "Spain"
    case uk = "United Kingdom"
    case us = "United States"
}


class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [Country]()
    var currentScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupButtonStyles()
        askQuestion()
    }

    
    func askQuestion() {
        let flagToGuess = _getFlagToGuess()
        let flagFileNameChoices = _getFlagChoices()
        
        title = "Which flag belongs to \(flagToGuess.rawValue)"
        
        button1.setImage(UIImage(named: flagFileNameChoices[0]), for: .normal)
        button2.setImage(UIImage(named: flagFileNameChoices[1]), for: .normal)
        button3.setImage(UIImage(named: flagFileNameChoices[2]), for: .normal)
    }
    
    
    func setupButtonStyles() {
        for button in [button1, button2, button3] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor(red: 1.00, green: 0.28, blue: 0.38, alpha: 1.00).cgColor
        }
    }
    
    
    func _getFlagToGuess() -> Country {
        return .russia
    }
    
    func _getFlagChoices() -> [String] {
        return [
            flagFileNames[0],
            flagFileNames[1],
            flagFileNames[2],
        ]
    }
}

