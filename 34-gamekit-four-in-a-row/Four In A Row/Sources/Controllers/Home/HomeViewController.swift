//
//  ViewController.swift
//  Four In A Row
//
//  Created by Brian Sipple on 2/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    enum BackgroundColor {
        static let red = #colorLiteral(red: 0.9146130681, green: 0, blue: 0.3108665347, alpha: 1)
        static let black = #colorLiteral(red: 0.09483634681, green: 0.09486005455, blue: 0.09483323246, alpha: 1)
    }
    
    @IBOutlet var columnButtons: [UIButton]!
    
    var board: Board!
    lazy var placedChipColumns: [[Chip]] = Array(repeating: [Chip](), count: Board.columns)


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetBoard()
    }


    // MARK: - Event handling
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        assert(column < columnButtons.count, "button tag should be able to index a button in memory")
        
        if let row = board.nextEmptyRow(inColumn: column) {
            board.add(chip: .red, toColumn: column)
            addChip(inColumn: column, row: row, colored: BackgroundColor.red)
        }
    }
    
    
    // MARK: - Helper functions
    
    func resetBoard() {
        board = Board()
        
        for var column in placedChipColumns {
            column.forEach { chip in chip.removeFromSuperview() }
            column.removeAll(keepingCapacity: true)
        }
    }
    

    func addChip(inColumn column: Int, row: Int, colored color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / CGFloat(Board.rows))
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if placedChipColumns[column].count < row + 1 {
            let newChip = Chip(frame: rect)
            
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
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
    
    // MARK: - Private functions
}

