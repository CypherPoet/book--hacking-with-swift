//
//  ViewController.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import GameplayKit

class HomeViewController: UIViewController {
    @IBOutlet var columnButtons: [UIButton]!
    
    enum GameplayState {
        case inactive
        case fullBoardDraw
        case playing(Player)
        case playerHasWon(Player)
    }
    
    // MARK: - Instance Properties
    let aiTimeCeiling: TimeInterval = 1.0
    var board: Board!
    
    lazy var placedChipColumns: [[Chip]] = Array(repeating: [Chip](), count: Board.columns)
    lazy var strategist = makeStrategist()
    lazy var thinkingSpinner = makeSpinner()

    var currentGameplayState = GameplayState.inactive {
        didSet { gameplayStateChanged() }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
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
    
    func setupUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: thinkingSpinner)
    }
    
    func resetGame() {
        board = Board()
        strategist.gameModel = board
        
        for i in 0..<placedChipColumns.count {
            placedChipColumns[i].forEach({ $0.removeFromSuperview() })
            placedChipColumns[i].removeAll(keepingCapacity: true)
        }
        
        toggleBoard(interactionEnabled: true)
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
        if board.isWin(for: board.currentPlayer) {
            currentGameplayState = .playerHasWon(board.currentPlayer)
        } else if board.isFull {
            currentGameplayState = .fullBoardDraw
        } else {
            board.switchCurrentPlayer()
            currentGameplayState = .playing(board.currentPlayer)
        }
    }
    
    func endGame(message: String) {
        let alertController = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Restart", style: .default) { [unowned self] _ in
            self.resetGame()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [unowned self] in
            self.present(alertController, animated: true)
        }
    }
    
    func columnForAIMove() -> Int? {
        guard let activePlayer = board.activePlayer else { return nil }
        
        if let move = strategist.bestMove(for: activePlayer) as? Move {
            return move.column
        }
        
        return nil
    }
    
    func makeAIMove(inColumn column: Int) {
        if let nextRow = board.nextEmptyRow(inColumn: column) {
            board.add(chip: board.currentPlayer.chipColor, toColumn: column)
            addChip(inColumn: column, row: nextRow, forPlayer: board.currentPlayer)
            
            advanceGame()
        }
    }
    
    func startAIMove() {
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            
            let elapsedTime = CFAbsoluteTimeGetCurrent() - strategistTime
            let delay = self.aiTimeCeiling - elapsedTime
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(inColumn: column)
            }
        }
    }
    
    func toggleBoard(interactionEnabled: Bool) {
        columnButtons.forEach { $0.isEnabled = interactionEnabled }
        interactionEnabled ? thinkingSpinner.stopAnimating() : thinkingSpinner.startAnimating()
    }
    
    
    // MARK: - Private functions
    
    private func gameplayStateChanged() {
        switch currentGameplayState {
        case .inactive:
            toggleBoard(interactionEnabled: false)
        case .playing(let currentPlayer):
            title = "\(currentPlayer.name)'s Turn"
            
            if board.currentPlayer.chipColor == .black {
                toggleBoard(interactionEnabled: false)
                startAIMove()
            } else {
                toggleBoard(interactionEnabled: true)
            }
        case .fullBoardDraw:
            endGame(message: "The board is full and game has ended in a draw.")
        case .playerHasWon(let currentPlayer):
            endGame(message: "\(currentPlayer.name) has won!")
        }
    }
    
    private func makeStrategist() -> GKMinmaxStrategist {
        let strategist = GKMinmaxStrategist()
        
        // Greater lookahead depth results in stronger play by a
        // strategist-controlled player, but at a cost of increased computation time and memory usage.
        strategist.maxLookAheadDepth = 7
        strategist.randomSource = GKARC4RandomSource()

        return strategist
    }
    
    private func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .gray)
        
        spinner.hidesWhenStopped = true

        return spinner
    }
}
