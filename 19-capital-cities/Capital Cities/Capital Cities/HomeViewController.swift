//
//  ViewController.swift
//  Capital Cities
//
//  Created by Brian Sipple on 2/5/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import MapKit

let initialCapitals = [
    "london": CapitalAnnotation(
        title: "London",
        coordinate: CLLocationCoordinate2D(latitude: 51.507351, longitude: -0.127758),
        shortDescription: "Home to the British Museum"
    ),
    "oslo": CapitalAnnotation(
        title: "Oslo",
        coordinate: CLLocationCoordinate2D(latitude: 59.913868, longitude: 10.752245),
        shortDescription: "Is also considered a county"
    ),
    "paris": CapitalAnnotation(
        title: "Paris",
        coordinate: CLLocationCoordinate2D(latitude: 48.856613, longitude: 2.352222),
        shortDescription: "Home to the Louvre"
    ),
    "rome": CapitalAnnotation(
        title: "",
        coordinate: CLLocationCoordinate2D(latitude: 41.902782, longitude: 12.496365),
        shortDescription: "Home to the Colosseum"
    ),
    "washington": CapitalAnnotation(
        title: "Washington D.C",
        coordinate: CLLocationCoordinate2D(latitude: 38.907192, longitude: -77.036873),
          shortDescription: "Not actually within any U.S. State"
    ),
    "canberra": CapitalAnnotation(
        title: "Canberra",
        coordinate: CLLocationCoordinate2D(latitude: -35.280937, longitude: 149.130005),
        shortDescription: "Became capital through a compromise between Sydney and Melbourne 😂"
    ),
    "seoul": CapitalAnnotation(
        title: "Seoul",
        coordinate: CLLocationCoordinate2D(latitude: 37.566536, longitude: 126.977966),
        shortDescription: "Hosted the 2002 FIFA World Cup"
    ),
]

let mapTypes = [
    "Standard": MKMapType.standard,
    "Satellite": MKMapType.satellite,
    "Satellite Flyover": MKMapType.satelliteFlyover,
    "Hybrid": MKMapType.hybrid,
    "Hybrid Flyover": MKMapType.hybridFlyover,
    "Muted Standard": MKMapType.mutedStandard,
]

class HomeViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var capitalAnnotations: [String: CapitalAnnotation]!
    let annotationReuseIdentifier = "Capital"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        capitalAnnotations = initialCapitals
        setupMap()
    }


    func setupMap() {
        mapView.addAnnotations(Array(capitalAnnotations!.values))
    }
    

    func switchMapStyle(action: UIAlertAction) {
        guard let mapType: MKMapType = mapTypes[action.title!] else {
            preconditionFailure("Couldn't get MKMapType from \(action.title!)")
        }
        
        mapView.mapType = mapType
    }
    

    @IBAction func selectMapStyle(_ sender: Any) {
        let chooser = UIAlertController(title: "Choose a map style.", message: nil, preferredStyle: .actionSheet)
        
        for (mapTypeKey, _) in mapTypes {
            chooser.addAction(UIAlertAction(title: mapTypeKey, style: .default, handler: switchMapStyle))
        }
        
        self.present(chooser, animated: true)
    }
}


extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CapitalAnnotation) {
            return nil
        }
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: self.annotationReuseIdentifier) {
            annotationView.annotation = annotation
            
            return annotationView
            
        } else {
            return makeNewCapitalAnnotationView(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let capitalAnnotation = view.annotation as? CapitalAnnotation {
            showDetailModal(forAnnotation: capitalAnnotation)
            
        }
    }
    
    
    func makeNewCapitalAnnotationView(_ annotation: MKAnnotation) -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: self.annotationReuseIdentifier)

        let button = UIButton(type: .detailDisclosure)
        
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = button
        
        return annotationView
    }
    
    func showDetailModal(forAnnotation annotation: CapitalAnnotation) {
        let alertController = UIAlertController(title: annotation.title, message: annotation.shortDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true)
    }
}
