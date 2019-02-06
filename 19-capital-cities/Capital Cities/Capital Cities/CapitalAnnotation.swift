//
//  Capital.swift
//  Capital Cities
//
//  Created by Brian Sipple on 2/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MapKit


class CapitalAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var shortDescription: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, shortDescription: String) {
        self.title = title
        self.coordinate = coordinate
        self.shortDescription = shortDescription
    }
}
