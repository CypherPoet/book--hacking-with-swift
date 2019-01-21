//
//  Asteroid.swift
//
// An asteroid classified by NASA JPL as a Near-Earth Object
//

import Foundation


struct Asteroid: Codable {
    let name: String
    let designation: String
    let absoluteMagnitudeH: Double
    let isPotentiallyHazardous: Bool
    let jplURL: URL
    let estimatedDiameterMin: Double
    let estimatedDiameterMax: Double
    
    /*
     Close-Approach Data
     
     📝 While the API tracks close-approach data relative to all planets in the solar system,
     we're looking for close-approach data relative to Earth
     */
    var missDistanceKM: Double?
//    var closeApproachDate: Date?
    var closeApproachDate: String?
    

    enum RootCodingKeys: String, CodingKey {
        case name
        case designation
        case absoluteMagnitudeH = "absolute_magnitude_h"
        case isPotentiallyHazardous = "is_potentially_hazardous_asteroid"
        case jplURL = "nasa_jpl_url"
        
        case estimatedDiameter = "estimated_diameter"
        case closeApproachData = "close_approach_data"
    }
    

    enum EstimatedDiameterKeys: String, CodingKey {
        case meters = "meters"
    }


    enum EstimatedDiameterMetersKeys: String, CodingKey {
        case estimatedDiameterMin = "estimated_diameter_min"
        case estimatedDiameterMax = "estimated_diameter_max"
    }


    enum CloseApproachKeys: String, CodingKey {
        case closeApproachDate = "close_approach_date"
        case missDistance = "miss_distance"
        case orbitingBody = "orbiting_body"
    }


    enum MissDistanceKeys: String, CodingKey {
        case kilometers
    }

    
    init(from decoder: Decoder) throws {
        let asteroidContainer = try decoder.container(keyedBy: RootCodingKeys.self)

        name = try asteroidContainer.decode(String.self, forKey: .name)
        designation = try asteroidContainer.decode(String.self, forKey: .designation)
        absoluteMagnitudeH = try asteroidContainer.decode(Double.self, forKey: .absoluteMagnitudeH)
        isPotentiallyHazardous = try asteroidContainer.decode(Bool.self, forKey: .isPotentiallyHazardous)
        jplURL = try asteroidContainer.decode(URL.self, forKey: .jplURL)

        let estimatedDiameterContainer = try asteroidContainer.nestedContainer(
            keyedBy: EstimatedDiameterKeys.self,
            forKey: .estimatedDiameter
        )

        let estimatedDiameterMetersContainer = try estimatedDiameterContainer.nestedContainer(
            keyedBy: EstimatedDiameterMetersKeys.self,
            forKey: .meters
        )

        estimatedDiameterMin = try estimatedDiameterMetersContainer.decode(Double.self, forKey: .estimatedDiameterMin)
        estimatedDiameterMax = try estimatedDiameterMetersContainer.decode(Double.self, forKey: .estimatedDiameterMax)

        var closeApproachUnkeyedContainer = try asteroidContainer.nestedUnkeyedContainer(forKey: .closeApproachData)
        
        while !closeApproachUnkeyedContainer.isAtEnd {
            let closeApproachContainer = try closeApproachUnkeyedContainer.nestedContainer(keyedBy: CloseApproachKeys.self)
            let orbitingBody = try closeApproachContainer.decode(String.self, forKey: .orbitingBody)

            if orbitingBody == "Earth" {
                closeApproachDate = try closeApproachContainer.decode(String.self, forKey: .closeApproachDate)
                
//                print("Close-approach date: \(closeApproachDate)")
                
                let missDistanceContainer = try closeApproachContainer.nestedContainer(
                    keyedBy: MissDistanceKeys.self,
                    forKey: .missDistance
                )
                
                missDistanceKM = try Double(missDistanceContainer.decode(String.self, forKey: .kilometers)) ?? 0.0
                
                break
            }
        }
    }
}



struct Asteroids: Codable {
    var nearEarthObjects: [Asteroid]
    
    enum CodingKeys: String, CodingKey {
        case nearEarthObjects = "near_earth_objects"
    }
}
