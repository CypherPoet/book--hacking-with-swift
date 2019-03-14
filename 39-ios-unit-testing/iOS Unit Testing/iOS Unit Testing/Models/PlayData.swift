//
//  PlayData.swift
//  iOS Unit Testing
//
//  Created by Brian Sipple on 3/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

class PlayData {
    private lazy var pathToWords = Bundle.main.path(forResource: "plays", ofType: "txt")
    
    var allWords: [String] = []
    var wordsSortedByCount: [String] = []
    private(set) var filteredWords: [String] = []
    
    var wordCounts: NSCountedSet! {
        didSet {
            wordCountsChanged()
        }
    }
    
    
    init() {
        loadWords()
        filteredWords = allWords
    }
}


// MARK: - Core Methods

extension PlayData {
    func applyCustomFilter(_ predicate: (_ word: String) -> Bool) {
        filteredWords = allWords.filter(predicate)
    }
    
    func setCountThreshold(_ minimumCount: Int) {
        filteredWords = allWords.filter { wordCounts.count(for: $0) >= minimumCount }
    }
}



// MARK: - Private Helper Methods

private extension PlayData {
    func loadWords() {
        guard let pathToWords = pathToWords else {
            fatalError("Failed to find path to words file")
        }
        
        do {
            let playsText = try String(contentsOfFile: pathToWords)

            let words = playsText
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter({ $0 != "" })
            
            wordCounts = NSCountedSet(array: words)
            
        } catch {
            print("Error while parsing plays file:\n\n\(error.localizedDescription)")
        }
    }
    
    func wordCountsChanged() {
        allWords = wordCounts.allObjects as! [String]
        
        wordsSortedByCount = allWords.sorted(by: {
            wordCounts.count(for: $0) > wordCounts.count(for: $1)
        })
    }
}

