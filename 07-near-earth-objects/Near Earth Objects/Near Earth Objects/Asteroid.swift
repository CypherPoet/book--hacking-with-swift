//
//  Asteroid.swift
//
// An asteroid classified by NASA JPL as a Near-Earth Object
//
struct Asteroid {
    let name: String
    let designation: String
    let absoluteMagnitudeH: Double
    let isPotentiallyHazardous: Bool
    let jplURL: String
    
    struct EstimatedDiameter {
        let minMeters: Double
        let maxMeters: Double
    }
        
    /*
     Close-Approach Data
     
     📝 While the API tracks close-approach data relative to all planets in the solar system,
     we're looking for close-approach data relative to Earth
     */
    let missDistanceKM: Double
    let closetApproachDate: String
}
