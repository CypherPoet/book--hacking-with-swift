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
    
    var activatedButtons = [UIButton]()
    var letterGroupButtons = [UIButton]()
    var solutionWords = [String]()
    var currentLevel = 1
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupButtons()
        setupLevel(number: currentLevel)
    }
    
    
    func setupLevel(number: Int) {
        if var (clueString, answerString, solutionLetterGroups, _solutionWords) = loadLevel(number: number) {
            solutionWords = _solutionWords
            cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            answersLabel.text = answerString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            makeLetterGroupButtons(from: solutionLetterGroups)
        }
    }

    
    func loadLevel(number levelNumber: Int) ->
        (clueString: String, answerString: String, solutionLetterGroups: [String], solutionWords: [String])? {
            if let filePath = Bundle.main.path(forResource: "level\(levelNumber)", ofType: "txt") {
                if let contents = try? String(contentsOfFile: filePath) {
                    var clueString = ""
                    var answerString = ""
                    var solutionLetterGroups = [String]()
                    var solutionWords = [String]()
                    
                    var lines = contents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let lineParts = line.components(separatedBy: ": ")
                        let solutionPart = lineParts[0]
                        let solutionWord = solutionPart.replacingOccurrences(of: "|", with: "")
                        
                        answerString += "\(solutionWord.count) letters\n"
                        clueString += "\(index + 1). \(lineParts[1])\n"
                        
                        solutionWords.append(solutionWord)
                        solutionLetterGroups += solutionPart.components(separatedBy: "|")
                    }
                    
                    solutionLetterGroups.shuffle()
                    return (clueString, answerString, solutionLetterGroups, solutionWords)
                }
            }
            return nil
    }
    
    
    func setupButtons() {
        for subview in view.subviews where subview.tag == 1001 {
            let letterGroupButton = subview as! UIButton
            
            letterGroupButton.addTarget(self, action: #selector(letterGroupTapped), for: .touchUpInside)
            letterGroupButtons.append(letterGroupButton)
        }
    }
    
    
    func makeLetterGroupButtons(from solutionLetterGroups: [String]) {
        if solutionLetterGroups.count == letterGroupButtons.count {
            for index in 0..<solutionLetterGroups.count {
                letterGroupButtons[index].setTitle(solutionLetterGroups[index], for: .normal)
            }
        }
    }

    
    @objc func letterGroupTapped(btn: UIButton) {
        currentAnswer.text! += btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }
    

    /*
        If the user guesses a correct answer, we'll change
        the answer's corresponding label (in the upper text area)
        to display the answer itself, rather than its letter count
     */
    @IBAction func submitTapped(_ sender: Any) {
        if let indexOfMatch = solutionWords.index(of: currentAnswer.text!) {
            activatedButtons.removeAll()  // remove all from our array -- but keep them "hidden" on the UI
            addCorrectAnswer(indexOfMatch: indexOfMatch)
            bumpScore()
        } else {
            promptAfterIncorrect()
        }
    }
    
    
    @IBAction func clearTapped(_ sender: Any) {
        clearAnswer()
    }
    
    
    func addCorrectAnswer(indexOfMatch: Int) {
        var answerStrings = answersLabel.text!.components(separatedBy: "\n")
        
        answerStrings[indexOfMatch] = currentAnswer.text!
        answersLabel.text = answerStrings.joined(separator: "\n")
        
        currentAnswer.text = ""
    }
    
    
    func bumpScore() {
        currentScore += 1
        
        if currentScore % 7 == 0 {
            // advance level
            promptForNextLevel()
        }
    }
    
    
    func promptForNextLevel() {
        let alertController = UIAlertController(
            title: "Well Done!",
            message: "Are you ready for the next level?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(alertController, animated: true)
    }
    
    
    func promptAfterIncorrect() {
        let alertController = UIAlertController(
            title: "Incorrect",
            message: "No solutions were found for that answer.",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Try again", style: .default) { [unowned self] (action: UIAlertAction) in
                self.clearAnswer()
            }
        )
                
        present(alertController, animated: true)
    }
    
    
    func levelUp(action: UIAlertAction) {
        currentLevel += 1
        solutionWords.removeAll(keepingCapacity: true)
        
        for button in letterGroupButtons {
            button.isHidden = false
        }
        
        setupLevel(number: currentLevel)
    }


    func clearAnswer() {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
}

