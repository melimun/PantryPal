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
    
    var itemName : String = ""
    var category : String = ""
    var inStock : Bool = false
    
    init(){
        self.itemName = ""
        self.category = ""
        self.inStock = false
    }
    
    init(itemName : String, category : String, inStock : Bool){
        self.itemName = itemName
        self.category = category
        self.inStock = inStock
    }
    
    init?(dictionary: [String: Any]){
        guard let itemName = dictionary["itemName"] as? String else{
            return nil
        }
        
        guard let category = dictionary["category"] as? String else{
            return nil
        }
        
        guard let inStock = dictionary["inStock"] as? Bool else{
            return nil
        }
        
        
        
        self.init(itemName: itemName, category: category, inStock: inStock)
        
    }
}
