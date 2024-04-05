//
//  ItemFirebase.swift
//  PantryPal
//
//  Created by Christian on 2024-04-05.
//

import Foundation
import FirebaseFirestoreSwift

struct ItemFirebase : Codable, Hashable{
    
    @DocumentID var id : String? = UUID().uuidString
    
}
