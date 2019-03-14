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

    var wordCounts: NSCountedSet!

    init() {
        loadWords()
    }
}

extension PlayData {
    var allWords: [String] {
        return wordCounts.allObjects as! [String]
    }
}


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
}

