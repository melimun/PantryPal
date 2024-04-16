//
//  CroceryItem.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-02-10.
//

import Foundation
import FirebaseFirestoreSwift

//model

struct Ingredient : Codable, Hashable{
    
    @DocumentID var id : String? = UUID().uuidString
    
    var ingredientImage : String = ""
    var ingredientName : String = ""
    var purchaseDate : String = ""
    var expirationDate : String = ""
    var price : Float = 0.0
    
    init(){
        self.ingredientImage = "NA"
        self.ingredientName = "NA"
        self.purchaseDate = "NA"
        self.expirationDate = "NA"
        self.price = 0.0
    }
    
    init(ingredientImage: String,  ingredientName: String, purchaseDate: String, expirationDate: String, price: Float) {
        
        self.ingredientImage = ingredientImage
        self.ingredientName = ingredientName
        self.purchaseDate = purchaseDate
        self.expirationDate = expirationDate
        self.price = price
    }
    
    //JSON object to Swift Object
    
//    //failable initializer
    init?(dictionary: [String: Any]){

        guard let ingredientImage = dictionary["ingredientImage"] as? String else{
            return nil
        }

        guard let ingredientName = dictionary["ingredientName"] as? String else{
            return nil
        }
        
        guard let purchaseDate = dictionary["purchaseDate"] as? String else{
            return nil
        }
        
        guard let expirationDate = dictionary["expirationDate"] as? String else{
            return nil
        }
        
        guard let price = dictionary["price"] as? Float else{
            return nil
        }
        
        self.init(ingredientImage: ingredientImage, ingredientName: ingredientName, purchaseDate: purchaseDate, expirationDate: expirationDate, price: price)
        
    }
}
