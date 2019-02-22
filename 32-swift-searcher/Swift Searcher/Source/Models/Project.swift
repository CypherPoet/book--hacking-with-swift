//
//  Project.swift
//  Swift Searcher
//
//

import UIKit

class Project: Codable {
    var projectNumber: Int
    var title: String
    var subtitle: String
    var isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case projectNumber = "project_number"
        case title
        case subtitle
        case isFavorite = "is_favorite"
    }
}
