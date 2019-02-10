//
//  ViewController.swift
//  Detect A Beacon
//
//  Created by Brian Sipple on 2/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import CoreLocation


class HomeViewController: UIViewController {
    @IBOutlet weak var nearestDistanceLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
//    lazy var regionUUID = UUID(uuidString: "96b81f8a-c522-40c0-b79f-411a72be9093")!
    lazy var regionUUID = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let regionMajorCode: CLBeaconMajorValue = 123
    let regionMinorCode: CLBeaconMinorValue = 456
    let regionIdentifier = "MuseumBeacon"
    
    var canScan: Bool {
        return (
            CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) &&
            CLLocationManager.isRangingAvailable()
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupLocationManager()
        setupUI()
    }
    
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
//        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.gray
    }
    
    func startScanning() {
        let beaconRegion = CLBeaconRegion(
            proximityUUID: regionUUID,
            major: regionMajorCode,
            minor: regionMinorCode,
            identifier: regionIdentifier
        )
        
        beaconRegion.notifyEntryStateOnDisplay = true
        
        // start monitoring for the existence of the region
        locationManager.startMonitoring(for: beaconRegion)
        
        // start measuring the distance between us and the beacon
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
    
    func update(withBeaconProximity proximity: CLProximity) {
        UIView.animate(
            withDuration: 0.8,
            animations: { [unowned self] in
                switch proximity {
                case .unknown:
                    self.nearestDistanceLabel.text = "UNKOWN"
                    self.view.backgroundColor = UIColor(hue: 5, saturation: 29, brightness: 100, alpha: 1)
                case .far:
                    self.nearestDistanceLabel.text = "FAR"
                    self.view.backgroundColor = UIColor(hue: 5, saturation: 46, brightness: 100, alpha: 1)
                case .near:
                    self.nearestDistanceLabel.text = "CLOSE"
                    self.view.backgroundColor = UIColor(hue: 5, saturation: 70, brightness: 100, alpha: 1)
                case .immediate:
                    self.nearestDistanceLabel.text = "RIGHT HERE"
                    self.view.backgroundColor = UIColor(hue: 5, saturation: 87, brightness: 100, alpha: 1)
                }
            }
        )
    }
}


// MARK - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if canScan {
                startScanning()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(withBeaconProximity: beacon.proximity)
        } else {
            update(withBeaconProximity: .unknown)
        }
    }
    
    
}

