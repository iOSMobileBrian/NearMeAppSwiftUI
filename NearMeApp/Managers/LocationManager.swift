//
//  LocationManager.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/5/24.
//

import Foundation
import MapKit
import Observation

enum LocationError: LocalizedError{
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case network
    case operationFailed
    
    var errorDescription: String?{
        switch self {
        case .authorizationDenied:
            return NSLocalizedString("Location access denied", comment: "")
        case .authorizationRestricted:
            return NSLocalizedString("Location access restricted", comment: "")
        case .unknownLocation:
            return NSLocalizedString("Unknown location", comment: "")
        case .accessDenied:
            return NSLocalizedString("Access denied", comment: "")
        case .network:
            return NSLocalizedString("Network failed", comment: "")
        case .operationFailed:
            return NSLocalizedString("Operation failed", comment: "")
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate{
    static let shared = LocationManager()
    let manager: CLLocationManager = CLLocationManager()
    var region: MKCoordinateRegion = MKCoordinateRegion()
    var error: LocationError = .unknownLocation
    
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
            error = .authorizationRestricted
        case .denied:
            error = .authorizationDenied
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
        if let clError = error as? CLError{
            switch clError.code{
                
            case .locationUnknown:
                self.error = .unknownLocation
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .network
          
            @unknown default:
                self.error = .operationFailed
            }
        }
    }
    
    
}
