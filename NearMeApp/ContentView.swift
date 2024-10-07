//
//  ContentView.swift
//  NearMeApp
//
//  Created by Brian Surface on 10/5/24.
//

import SwiftUI
import MapKit


enum MapOptions:String, Identifiable, CaseIterable{
    case standard
    case hybrid
    case imagery
    
    var id: String{
        self.rawValue
    }
    
    var mapStyle:MapStyle {
    switch self{
    case .standard:
        return .standard
    case .hybrid:
        return .hybrid
    case .imagery:
        return .imagery
        }
    }
}

struct ContentView: View {
    
    @State private var locationManager = LocationManager.shared
    @State private var position:MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedMapOption: MapOptions = .standard
    @State private var query:String = ""
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    
    var body: some View {
        ZStack(alignment: .top ){
        Map(position: $position){
            UserAnnotation()
        }.mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }.sheet(isPresented: .constant(true), content: {
            VStack{
                TextField("Search", text: $query)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onSubmit {
                        
                    }
            }
            
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        })
        
        .mapStyle(selectedMapOption.mapStyle)
          .onChange(of: locationManager.region) {
                    position = .region(locationManager.region)
                }
            
           
            
//            Picker("Map Style", selection: $selectedMapOption) {
//                ForEach(MapOptions.allCases){ mapOption in
//                    Text(mapOption.rawValue.capitalized).tag(mapOption)
//                }
//            }.pickerStyle(.segmented)
//                .background(.white)
//                .padding([.top], 50)
        }
    }
}

#Preview {
    ContentView()
}
