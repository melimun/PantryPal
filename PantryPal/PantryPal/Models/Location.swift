//
//  Location.swift
//  PantryPal
//
//  Created by Christian on 2024-04-05.
//

import Foundation

import MapKit

struct Location: Identifiable, Hashable {
    
    let placemark: MKPlacemark
    
    var id: UUID {
        return UUID()
    }
    
    var name: String {
        self.placemark.name ?? ""
    }
    
    var title: String {
        self.placemark.title ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        self.placemark.coordinate
    }
    
    var date: Date{
        return Date()
    }
    
}
