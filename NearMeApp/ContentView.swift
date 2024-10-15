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

enum DisplayMode {
    case search
    case detail
}

struct ContentView: View {
    
    @State private var locationManager = LocationManager.shared
    @State private var position:MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedMapOption: MapOptions = .standard
    @State private var query:String = ""
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    @State private var isSearching: Bool = false
    @State private var mapItems : [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedMapItem: MKMapItem?
    @State private var displayMode: DisplayMode = .search
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var route: MKRoute?
    
    private func requestCalculateDirections(){
        route = nil
        if let selectedMapItem {
            guard let currentUserLocation = locationManager.manager.location else {return}
            let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentUserLocation.coordinate))
            
            task {
                self.route = await calculateDirection(from: startingMapItem, to: selectedMapItem)
            }
        }
    }
   
    
    var body: some View {
        ZStack{
            Map(position: $position, selection: $selectedMapItem){
            ForEach(mapItems, id: \.self){ mapItem in
                Marker(item: mapItem)
            }
                if let route {
                    MapPolyline(route)
                        .stroke(.blue,lineWidth: 8)
                }
            UserAnnotation()
        }.mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }.sheet(isPresented: .constant(true), content: {
            VStack{
                switch displayMode {
                case .search:
                    SearchBarView(search: $query, isSearching: $isSearching)
                     PlaceListView(mapItems: mapItems, selectedMapItem: $selectedMapItem)
                case .detail:
                    SelectedPlaceDetailView(mapItem: $selectedMapItem).padding()
                    LookAroundPreview(initialScene: lookAroundScene)
                        .task(id: selectedMapItem) {
                            lookAroundScene = nil
                            if let selectedMapItem{
                                let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
                                lookAroundScene = try? await request.scene
                            }
                            
                        }
                }
               
                Spacer()
            }
                .presentationDetents([.fraction(0.15), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        })
        .onChange(of: selectedMapItem, {
            if selectedMapItem != nil {
                displayMode = .detail
            }else{
                displayMode = .search
            }
        })
        .onMapCameraChange { context in
           visibleRegion = context.region
        }
        .mapStyle(selectedMapOption.mapStyle)
          .onChange(of: locationManager.region) {
              position = .region(visibleRegion!)
                }
            
        }.task(id: isSearching) {
            do{
                mapItems = try await performSearch(searchTerm: query, visibleRegion: locationManager.region)
                print(mapItems)
                isSearching = false
            }catch{
                mapItems = []
                print(error.localizedDescription)
                isSearching = false
            }
        }
    }
}

#Preview {
    ContentView()
}
