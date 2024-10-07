//
//  LocationManager.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/5/24.
//

import Foundation
import MapKit
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate{
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    
    override init() {
        super.init()
        self.manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways,.authorizedWhenInUse:
            manager.requestLocation()
        case .authorized:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("unknown")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map{
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    
}
