//
//  WalmartMap.swift
//  PantryPal
//
//  Created by Christian on 2024-04-12.
//

import Foundation
import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    
    var control: WalmartMap
    
    init(_ control: WalmartMap) {
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //this is for annotation customization
        let identifier = "LocationAnnotation"
        var annotationView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        // Set pin color
        
        return annotationView
    }






        
}//coordinator

struct WalmartMap : UIViewRepresentable{
    
    let locations: [Location]
    typealias UIViewType = MKMapView
    
    @EnvironmentObject var fireDBHelper : FireDBHelper

    @EnvironmentObject var locationHelper : LocationHelper
    
    //specify initial state to show the view
    func makeUIView(context: Context) -> MKMapView {
        
        let centerPoint : CLLocationCoordinate2D
        
        if (self.locationHelper.currentLocation != nil){
            
            centerPoint = self.locationHelper.currentLocation!.coordinate
        }else{
            centerPoint = CLLocationCoordinate2D(latitude: 43.8595, longitude: -79.2345)
        }
        
        
        let map = MKMapView()
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isPitchEnabled = true
        map.mapType = .standard
        
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<WalmartMap>) {
        
        let centerPoint : CLLocationCoordinate2D
        
        if (self.locationHelper.currentLocation != nil){
            centerPoint = self.locationHelper.currentLocation!.coordinate
        }else{
            centerPoint = CLLocationCoordinate2D(latitude: 43.8595, longitude: -79.2345)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerPoint, span: span)
        
        uiView.setRegion(region, animated: true)
    }
    
    


    
    
}
