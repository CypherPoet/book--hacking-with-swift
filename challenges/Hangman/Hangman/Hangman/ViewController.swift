//
//  ViewController.swift
//  Hangman
//
//  Created by Brian Sipple on 1/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    @IBOutlet weak var ropeSlackBox1: UILabel!
    @IBOutlet weak var ropeSlackBox2: UILabel!
    @IBOutlet weak var ropeSlackBox3: UILabel!
    @IBOutlet weak var ropeSlackBox4: UILabel!
    @IBOutlet weak var ropeSlackBox5: UILabel!
    @IBOutlet weak var ropeSlackBox6: UILabel!
    @IBOutlet weak var ropeSlackBox7: UILabel!
    
    var ropeSlackBoxes = [UILabel]()
    var letterButtons = [UIButton]()
    let letterButtonTag = 1001
    
    var levelAnswer = ""
    var lettersGuessed = [Character]()
    
    
    var currentAnswerText = "" {
        didSet {
            answerTextLabel.text = self.currentAnswerText.uppercased()
        }
    }
    
    var currentLevel = 0 {
        didSet {
            currentLevelLabel.text = "Level: \(self.currentLevel)"
        }
    }
    
    var remainingMistakes = 7 {
        didSet {
            updateSlackBoxes(showing: remainingMistakes)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        currentLevel = 1
        ropeSlackBoxes += [ropeSlackBox1, ropeSlackBox2, ropeSlackBox3, ropeSlackBox4, ropeSlackBox5, ropeSlackBox6, ropeSlackBox7]
        initLetterButtons()
        loadLevel(number: currentLevel)
        showAllButtons()
    }
    
    
    func loadLevel(number levelNumber: Int) {
        remainingMistakes = 7
        loadAnswer(forLevel: levelNumber)
    }

    
    func loadAnswer(forLevel levelNumber: Int) {
        if let answer = pickAnswerFromFile(name: "level-\(levelNumber)-words") {
            print("Loaded answer: \(answer)")
            var startingAnswerText = ""
            
            for character in answer {
                if character == " " {
                    startingAnswerText += " "
                } else {
                    startingAnswerText += "*"
                }
            }
            
            levelAnswer = answer
            currentAnswerText = startingAnswerText
            
        } else {
            showLoadingError(message: "Unable to load answer from file")
        }
    }
    
    
    func showAllButtons() {
        for letterButton in letterButtons {
            letterButton.isHidden = false
        }
    }
    
    
    @objc func handleLetterChoice(btn: UIButton) {
        print("Handling \(btn.titleLabel!.text!)")
        let letter = Character(btn.titleLabel!.text!.lowercased())
        
        if levelAnswer.contains(letter) {
            addToAnswerDisplay(letter: letter)
            
            if currentAnswerText == levelAnswer {
                handleSuccess()
            }
            
        } else {
            remainingMistakes -= 1
        }
        
        btn.isHidden = true
    }
    
    
    func updateSlackBoxes(showing numBoxesShowing: Int) {
        if numBoxesShowing == 0 {
            handleHanging()
        }
        
        for index in 0..<ropeSlackBoxes.count {
            let box = ropeSlackBoxes[index]
            
            if (index + 1 <= numBoxesShowing) {
                box.isHidden = false
            } else {
                box.isHidden = true
            }
        }
    }
    
    
    func pickAnswerFromFile(name: String) -> String? {
        if let filePath = Bundle.main.path(forResource: name, ofType: "txt") {
            if let contents = try? String(contentsOfFile: filePath) {
                let answerChoices = contents.components(separatedBy: "\n")
                
                var answer = ""
                while answer == "" {
                    answer = answerChoices.randomElement()!
                }
                
                return answer
            }
        }
        return nil
    }
    
    
    func showLoadingError(message: String) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: "Try Starting Over", style: .default) { [unowned self] (action: UIAlertAction) in
                self.loadLevel(number: 1)
            }
        )
        
        present(alertController, animated: true)
    }
    
    
    func addToAnswerDisplay(letter letterToAdd: Character) {
        var newAnswerText = ""
        
        var index = 0
        for character in levelAnswer {
            if character == letterToAdd {
                newAnswerText += String(character)
            } else {
                newAnswerText += String(Array(currentAnswerText)[index])
            }
            index += 1
        }
        
        currentAnswerText = newAnswerText
    }
    
    
    func handleHanging() {
        let alertController = UIAlertController(
            title: "Game Over",
            message: "You made too many mistakes. The correct answer was \"\(levelAnswer.uppercased())\"",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Restart Game", style: .default) { [unowned self] (_: UIAlertAction) in
                self.currentLevel = 1
                self.showAllButtons()
                self.loadLevel(number: 1)
            }
        )
        
        present(alertController, animated: true)
    }
    
    
    func handleSuccess() {
        let alertController = UIAlertController(
            title: "Well Done 👏",
            message: "You survived the hangman... for now.",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Keep Going", style: .default) { [unowned self] (_: UIAlertAction) in
                self.currentLevel += 1
                self.showAllButtons()
                self.loadLevel(number: self.currentLevel)
            }
        )
        
        present(alertController, animated: true)
    }
    
    
    func initLetterButtons() {
        for subview in view.subviews where subview.tag == letterButtonTag {
            let button = subview as! UIButton
            
            button.addTarget(self, action: #selector(handleLetterChoice), for: .touchUpInside)
            letterButtons.append(button)
        }
    }
}

