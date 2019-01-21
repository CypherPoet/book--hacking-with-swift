//
//  NEOHistory.swift
//  Near Earth Objects
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct NEOHistory: Codable {
    let nearEarthObjectCount: Int
    let closeApproachCount: Int
    let lastUpdated: String
    let source: String
    let jplURL: URL
    
    enum CodingKeys: String, CodingKey {
        case nearEarthObjectCount = "near_earth_object_count"
        case closeApproachCount = "close_approach_count"
        case lastUpdated = "last_updated"
        case source = "source"
        case jplURL = "nasa_jpl_url"
    }
}
