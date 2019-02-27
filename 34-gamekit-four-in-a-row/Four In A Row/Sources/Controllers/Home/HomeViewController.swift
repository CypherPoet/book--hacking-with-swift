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
    
    var board: Board!
    lazy var placedChipColumns: [[UIView]] = makeColumns()
    lazy var slots: [Chip.Color] = makeSlots()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetBoard()
    }


    // MARK: - Event handling
    
    @IBAction func makeMove(_ sender: UIButton) {
    }
    
    
    // MARK: - Helper functions
    
    func resetBoard() {
        board = Board()
        
        for var column in placedChipColumns {
            column.forEach { chip in chip.removeFromSuperview() }
            column.removeAll(keepingCapacity: true)
        }
    }
    
    
    // MARK: - Private functions
    
    private func makeColumns() -> [[UIView]] {
        var columns = [[UIView]]()
        
        for _ in 0 ..< Board.columns {
            columns.append([UIView]())
        }
        
        return columns
    }
    
    private func makeSlots() -> [Chip.Color] {
        return Array(repeating: .none, count: Board.rows * Board.columns)
    }
}

