//
//  MapView.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/5/24.
//

import Foundation
import UIKit
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable{
    
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map;
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
           return Coordinator(self)
       }

       class Coordinator: NSObject, MKMapViewDelegate {
           var parent: MapView

           init(_ parent: MapView) {
               self.parent = parent
           }

           // Handle MKMapView delegate methods here if needed, e.g., regionDidChangeAnimated, etc.
       }
}
