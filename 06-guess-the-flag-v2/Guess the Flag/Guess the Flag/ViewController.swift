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
    @IBOutlet var scoreLabel: UILabel!
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Current Score: \(self.currentScore)"
        }
    }
    
    var flagChoiceKeys = [String]()
    var correctFlagKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        currentScore = 0
        setupButtonStyles()
        askQuestion()
    }

    
    func askQuestion() {
        flagChoiceKeys = Array(flagFilePathsAndNames.keys.shuffled()[..<3])
        correctFlagKey = flagChoiceKeys.randomElement()

        if let _key = correctFlagKey {
            if let flagName = flagFilePathsAndNames[_key] {
                // 📝 If we didn't get here, that would be a serious problem that needed more robust error handling
                title = "Which flag belongs to \(flagName)?"
            }
        }
        
        for (index, button) in [button1, button2, button3].enumerated() {
            button?.setImage(UIImage(named: flagChoiceKeys[index]), for: .normal)
        }
    }
    
    
    func setupButtonStyles() {
        for button in [button1, button2, button3] {
            button?.layer.shadowRadius = 3.0
            button?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0);
            button?.layer.shadowOpacity = 1.0
            button?.layer.shadowColor = UIColor(red:0.13, green:0.14, blue:0.21, alpha:1.00).cgColor
        }
    }
    
    
    func handleChoice(wasCorrect: Bool) {
        var responseMessage: String
        
        if wasCorrect {
            title = "Correct!"
            responseMessage = "You just gained 1 point."
            currentScore += 1
        } else {
            title = "Incorrect!"
            responseMessage = "You just lost 3 points"
            currentScore = max(0, currentScore - 3)
        }
        
        let alertController = UIAlertController(title: title, message: responseMessage, preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: "Continue", style: .default, handler: _askAnotherQuestion)
        )
        
        present(alertController, animated: true)
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let flagKeyChosen = flagChoiceKeys[sender.tag]
        
        if flagKeyChosen == correctFlagKey {
            handleChoice(wasCorrect: true)
        } else {
            handleChoice(wasCorrect: false)
        }
    }
    
    /// callback for the UIAlertAction that conforms to the signature it expects
    /// (that is, taking a UIAlertAction argument).
    ///
    /// All we really want to do, though, is ask another quesstion, so this function
    /// just hides the handler implementation detail away from `askQuestion`
    func _askAnotherQuestion(action: UIAlertAction) {
        askQuestion()
    }
}

