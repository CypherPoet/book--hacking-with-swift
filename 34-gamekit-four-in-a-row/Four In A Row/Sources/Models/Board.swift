//
//  Board.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import GameplayKit

class Board: NSObject {
    // MARK: - Static Properties
    
    static let rows = 6
    static let columns = 7
    
    static var slotCapacity: Int {
        return Board.rows * Board.columns
    }
    
    enum ChipColor: Int {
        case none = 0
        case red
        case black
    }
    
    
    // MARK: - Instance Properties
    
    var slots: [ChipColor]
    var currentPlayer: Player = Player.allPlayers[0]
    
    var isFull: Bool {
        return !slots.contains(.none)
    }
    
    
    // MARK: - Lifecylcle
    
    override init() {
        self.slots = Array(repeating: .none, count: Board.slotCapacity)
        
        super.init()
    }
    
    
    // MARK: - Methods
    
    func color(inColumn column: Int, row: Int) -> ChipColor {
        return slots[slotIndex(forColumn: column, row: row)]
    }
    
    func set(color: ChipColor, inColumn column: Int, row: Int) {
        slots[slotIndex(forColumn: column, row: row)] = color
    }
    
    
    func nextEmptyRow(inColumn column: Int) -> Int? {
        for row in 0 ..< Board.rows {
            if color(inColumn: column, row: row) == .none {
                return row
            }
        }
        
        return nil
    }
    
    func canMove(inColumn column: Int) -> Bool {
        return nextEmptyRow(inColumn: column) != nil
    }
    
    
    func add(chip color: ChipColor, toColumn column: Int) {
        guard let row = nextEmptyRow(inColumn: column) else { return }
        
        set(color: color, inColumn: column, row: row)
    }
    
    func switchCurrentPlayer() {
        currentPlayer = currentPlayer.opponent
    }
    

    func hasHorizontalWin(row: Int, column: Int, color: ChipColor) -> Bool {
        for rowOffset in 0 ... 3 {
            if row + rowOffset >= Board.rows {
                return false
            }
            
            if slots[slotIndex(forColumn: column, row: row + rowOffset)] != color {
                return false
            }
        }
        return true
    }
    
    
    func hasVerticalWin(row: Int, column: Int, color: ChipColor) -> Bool {
        for columnOffset in 0 ... 3 {
            if column + columnOffset >= Board.columns {
                return false
            }
            
            if slots[slotIndex(forColumn: column + columnOffset, row: row)] != color {
                return false
            }
        }
        return true
    }
    
    
    func hasDiagonalWin(row: Int, column: Int, color: ChipColor, rowDirection: Int = 1) -> Bool {
        for offset in 0...3 {
            if column + offset >= Board.columns {
                return false
            }
            
            if row + (offset * rowDirection) >= Board.rows {
                return false
            }
            
            if row + (offset * rowDirection) < 0 {
                return false
            }
            
            // search diagonal rightwards and either upwards or downwards (depending on the `rowDirection` multiplier)
            if slots[slotIndex(forColumn: column + offset, row: row + (offset * rowDirection))] != color {
                return false
            }
        }
        return true
    }
    

    // MARK: - Private functions
    
    
    /// Computes the index of a slot
    ///
    /// - Parameters:
    ///   - column: 0-based column number, moving left-to-right
    ///   - row: 0-based row number, moving bottom-to-top
    /// - Returns: the corresponding index to the `slots` array
    private func slotIndex(forColumn column: Int, row: Int) -> Int {
        return (Board.rows * column) + row
    }
}


extension Board: GKGameModel {
    /**
     Victory occurs when a player has lined up four consecutive chips
     in any direction (horizontally, vertically or diagonally)
     */
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chipColor = (player as! Player).chipColor
        
        for row in 0 ..< Board.rows {
            for column in 0 ..< Board.columns {
                if hasHorizontalWin(row: row, column: column, color: chipColor) { return true }
                if hasVerticalWin(row: row, column: column, color: chipColor) { return true }
                if hasDiagonalWin(row: row, column: column, color: chipColor, rowDirection: 1) { return true }
                if hasDiagonalWin(row: row, column: column, color: chipColor, rowDirection: -1) { return true }
            }
        }
        
        return false
    }
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        guard let board = gameModel as? Board else { return }
        slots = board.slots
        currentPlayer = board.currentPlayer
    }
    
    /**
        If `isWin(for:)` is true either for the player or their opponent we return nil.
        If not, we call `canMove(in:)` for every column to see if the AI can move in each column.
        If so, we create a new Move object to represent that column, and add it to an array of possible moves.”
     */
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let player = player as? Player else { return nil }
        
        if isWin(for: player) || isWin(for: player.opponent) {
            return nil
        }
        
        return (0 ..< Board.columns).reduce([GKGameModelUpdate]()) { (moves, column) -> [GKGameModelUpdate] in
            if canMove(inColumn: column) {
                return moves + [Move(column: column)]
            }
            return moves
        }
    }
    
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let move = gameModelUpdate as? Move else { return }
        
        add(chip: currentPlayer.chipColor, toColumn: move.column)
        currentPlayer = currentPlayer.opponent
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let boardCopy = Board()
        boardCopy.setGameModel(self)
        
        return boardCopy
    }
    
    func score(for player: GKGameModelPlayer) -> Int {
        if let player = player as? Player {
            if isWin(for: player) {
                return 1000
            } else if isWin(for: player.opponent) {
                return -1000
            }
        }
        
        return 0
    }
}
