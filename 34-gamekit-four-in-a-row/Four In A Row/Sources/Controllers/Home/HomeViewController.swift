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
    
    enum GameplayState {
        case inactive
        case fullBoardDraw
        case playing(Player)
        case playerHasWon(Player)
    }
    
    
    // MARK: - Instance Properties
    
    var board: Board!
    lazy var placedChipColumns: [[Chip]] = Array(repeating: [Chip](), count: Board.columns)

    var currentGameplayState = GameplayState.inactive {
        didSet { gameplayStateChanged() }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetGame()
    }


    // MARK: - Event handling
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        assert(column < columnButtons.count, "button tag should be able to index a button in memory")
        
        if let row = board.nextEmptyRow(inColumn: column) {
            board.add(chip: board.currentPlayer.chipColor, toColumn: column)
            addChip(inColumn: column, row: row, forPlayer: board.currentPlayer)
            
            advanceGame()
        }
        
    }
    
    
    // MARK: - Helper functions
    
    func resetGame() {
        board = Board()

        for i in 0..<placedChipColumns.count {
            placedChipColumns[i].forEach({ $0.removeFromSuperview() })
            placedChipColumns[i].removeAll(keepingCapacity: true)
        }
        
        currentGameplayState = .playing(board.currentPlayer)
    }
    

    func addChip(inColumn column: Int, row: Int, forPlayer player: Player) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / CGFloat(Board.rows))
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if placedChipColumns[column].count < row + 1 {
            let newChip = Chip(frame: rect)
            
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = player.uiColor
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseIn], animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChipColumns[column].append(newChip)
        }
    }
    
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let columnButton = columnButtons[column]
        let chipSize = self.chipSize(fromColumnButton: columnButton)
        
        let x = columnButton.frame.midX
        let y = columnButton.frame.maxY - (chipSize * CGFloat(row)) - (chipSize / 2)
        
        return CGPoint(x: x, y: y)
    }
    
    
    func chipSize(fromColumnButton columnButton: UIButton) -> CGFloat {
        return min(columnButton.frame.width, columnButton.frame.height / CGFloat(Board.rows))
    }
    
    
    
    func advanceGame() {
        if board.isFull {
            if board.isWin(for: board.currentPlayer) {
                currentGameplayState = .playerHasWon(board.currentPlayer)
            } else {
                currentGameplayState = .fullBoardDraw
            }
        } else {
            if board.isWin(for: board.currentPlayer) {
                currentGameplayState = .playerHasWon(board.currentPlayer)
            } else {
                currentGameplayState = .playing(board.currentPlayer)
                board.switchCurrentPlayer()
            }
        }
    }
    
    
    func endGame(message: String) {
        let alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            self.resetGame()
        })
        
        present(alertController, animated: true)
    }
    
    
    // MARK: - Private functions
    
    private func gameplayStateChanged() {
        switch currentGameplayState {
        case .inactive:
            break
        case .playing(let currentPlayer):
            title = "\(currentPlayer.name)'s Turn"
        case .fullBoardDraw:
            endGame(message: "The board is full and game has ended in a draw.")
        case .playerHasWon(let currentPlayer):
            endGame(message: "\(currentPlayer.name) has won!")
        }
    }
    
}

