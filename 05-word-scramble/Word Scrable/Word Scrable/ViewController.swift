//
//  ViewController.swift
//  Word Scrable
//
//  Created by Brian Sipple on 1/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var currentSubject: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadWords()
        setupNavbar()
        startGame()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    
    func loadWords() {
        if let pathToStartWords = Bundle.main.path(forResource: "starting-words", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: pathToStartWords) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
    }
    
    
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
    }

    
    func startGame() {
        currentSubject = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)

        title = "Make an anagram from \"\(currentSubject!)\"."
        tableView.reloadData()
    }
    
    
    /*
        Shows a UIAlertController with space for the user to enter an answer.
     
        When the user clicks Submit to that alert controller,
        the answer is checked to make sure it's valid.
     */
    @objc func promptForAnswer() {
        let alertController = UIAlertController(
            title: "Enter an anagram for \(currentSubject!)",
            message: nil,
            preferredStyle: .alert
        )
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, alertController] (action: UIAlertAction) in
            let answer = alertController.textFields![0]
         
            self.handleSubmitAnswer(answer: answer.text!)
        }
        
        alertController.addTextField()
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    
    func handleSubmitAnswer(answer: String) {
        print("Handling answer of \"\(answer)\"")
    }
}

