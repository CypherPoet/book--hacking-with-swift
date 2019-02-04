//
//  File.swift
//  Apple Notes Imitation
//
//  Created by Brian Sipple on 2/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Folder: Codable {
    var title: String
    var notes: [Note]
}

