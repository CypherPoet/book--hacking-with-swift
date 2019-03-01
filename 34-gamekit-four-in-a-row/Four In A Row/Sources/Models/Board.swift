//
//  Board.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

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
    
    
    /**
        Victory occurs when a player has lined up four consecutive chips
        in any direction (horizontally, vertically or diagonally)
     */
    func hasWin(forPlayer player: Player) -> Bool {
        for row in 0 ..< Board.rows {
            for column in 0 ..< Board.columns {
                if hasHorizontalWin(row: row, column: column, color: player.chipColor) { return true }
                if hasVerticalWin(row: row, column: column, color: player.chipColor) { return true }
                if hasDiagonalWin(row: row, column: column, color: player.chipColor, rowDirection: 1) { return true }
                if hasDiagonalWin(row: row, column: column, color: player.chipColor, rowDirection: -1) { return true }
            }
        }
        
        return false
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
