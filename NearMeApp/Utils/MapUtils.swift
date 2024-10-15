//
//  MapUtils.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/7/24.
//

import Foundation
import MapKit

func calculateDistance(from: CLLocation, to: CLLocation)-> Measurement<UnitLength>{
    let distanceInMeters = from.distance(from: to)
    return Measurement(value: distanceInMeters, unit: .meters)
}

func calculateDirection(from: MKMapItem, to: MKMapItem) async -> MKRoute?{
    let directionsRequest = MKDirections.Request()
    directionsRequest.transportType = .automobile
    directionsRequest.source = from
    directionsRequest.destination = to
    
    let directions = MKDirections(request: directionsRequest)
    let response =  try? await directions.calculate()
    return response?.routes.first
}

func performSearch(searchTerm: String, visibleRegion: MKCoordinateRegion?) async throws ->  [MKMapItem]{
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTerm
    request.resultTypes = .pointOfInterest
    
    guard let region = visibleRegion else {return []}
    request.region = region
    
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    return response.mapItems
}
