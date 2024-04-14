//
//  MapView.swift
//  PantryPal
//
//  Created by Christian on 2024-04-03.
//


import SwiftUI
import MapKit

struct MapView : View{
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 20.7, longitude: -75), span : MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
      
    var body : some View{
        NavigationView{
            VStack{
                Map(coordinateRegion: $region)
                
                Button(action: {
                    
                }, label: {
                    Text("Find Nearby Store")
                })
            }
        }
    }
        
    
}
