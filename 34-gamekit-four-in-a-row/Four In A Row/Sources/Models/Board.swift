//
//  Board.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class Board: NSObject {
    // MARK: - Properties
    
    static let rows = 6
    static let columns = 7
    
    static let slotCount = {
        return rows * columns
    }
    
    enum Color: Int {
        case none = 0
        case red
        case black
    }
    
    var slots: [Color]
    
    
    // MARK: - Lifecylcle
    
    override init() {
        self.slots = Array(repeating: .none, count: Board.rows * Board.columns)
        
        super.init()
    }
    
    
    // MARK: - Methods
    
    func color(inColumn column: Int, row: Int) -> Color {
        return slots[slotIndex(forColumn: column, row: row)]
    }
    
    func set(color: Color, inColumn column: Int, row: Int) {
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
    
    
    func add(chip color: Color, toColumn column: Int) {
        guard let row = nextEmptyRow(inColumn: column) else { return }
        
        set(color: color, inColumn: column, row: row)
    }
    

    // MARK: - Private functions
    
    
    /// Computes the index of a slot
    ///
    /// - Parameters:
    ///   - column: 0-based column number, moving left-to-right
    ///   - row: 0-based row number, moving top-to-bottom
    /// - Returns: the corresponding index to the `slots` array
    private func slotIndex(forColumn column: Int, row: Int) -> Int {
        return (Board.rows * column) + row
    }
}
