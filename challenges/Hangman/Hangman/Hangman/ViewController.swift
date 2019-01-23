//
//  ViewController.swift
//  Hangman
//
//  Created by Brian Sipple on 1/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    @IBOutlet weak var ropeSlackBox1: UILabel!
    @IBOutlet weak var ropeSlackBox2: UILabel!
    @IBOutlet weak var ropeSlackBox3: UILabel!
    @IBOutlet weak var ropeSlackBox4: UILabel!
    @IBOutlet weak var ropeSlackBox5: UILabel!
    @IBOutlet weak var ropeSlackBox6: UILabel!
    @IBOutlet weak var ropeSlackBox7: UILabel!

    let letterButtonTag = 1001
    
    var answer = ""
    var remainingGuesses = 7
    var lettersGuessed = [Character]()
    
    
    var currentAnswerText = "" {
        didSet {
            answerText.text = self.currentAnswerText
        }
    }
    
    var currentLevel = 0 {
        didSet {
            currentLevelLabel.text = "Level: \(self.currentLevel)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        currentLevel = 1
        loadAnswer()
        setupUIForWord()
    }

    
    func loadAnswer() {
        answer = "apple a"
        
        var startingAnswerText = ""
        
        for character in answer {
            if character == " " {
                startingAnswerText += " "
            } else {
                startingAnswerText += "*"
            }
        }
        
        currentAnswerText = startingAnswerText
    }
    
    
    func setupUIForWord() {
        for subview in view.subviews where subview.tag == letterButtonTag {
            let letterButton = subview as! UIButton
            
            letterButton.addTarget(self, action: #selector(handleLetterChoice), for: .touchUpInside)
        }
    }
    
    
    @objc func handleLetterChoice(btn: UIButton) {
        print("Handling \(btn.titleLabel!.text!)")
    }
    
}

