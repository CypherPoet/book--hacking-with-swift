//
//  Project.swift
//  Swift Searcher
//
//

import UIKit

struct Project: Codable {
    var projectNumber: Int
    var title: String
    var subtitle: String
    
    enum CodingKeys: String, CodingKey {
        case projectNumber = "project_number"
        case title
        case subtitle
    }
}
