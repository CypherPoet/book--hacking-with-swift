//
//  City.swift
//  City Facts
//
//  Created by Brian Sipple on 1/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct City: Codable {
    let name: String
    let country: String
    let population: Int
    let yearFounded: String
    let lastCensusYear: Int
    let backgroundImageName: String
    let flagImageName: String
    let description: String
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case country
        case population
        case yearFounded = "year_founded"
        case lastCensusYear = "last_census_year"
        case backgroundImageName = "background_image_name"
        case flagImageName = "flag_image_name"
        case description
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        yearFounded = try container.decode(String.self, forKey: .yearFounded)
        population = try container.decode(Int.self, forKey: .population)
        lastCensusYear = try container.decode(Int.self, forKey: .lastCensusYear)
        country = try container.decode(String.self, forKey: .country)
        backgroundImageName = try container.decode(String.self, forKey: .backgroundImageName)
        flagImageName = try container.decode(String.self, forKey: .flagImageName)
        description = try container.decode(String.self, forKey: .description)
    }
}


struct Cities: Codable {
    var cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case cities
    }
}
