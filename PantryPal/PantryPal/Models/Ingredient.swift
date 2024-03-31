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
    
    var firstname : String = ""
    var lastname : String = ""
    var program : String = ""
    var ccr : Int = 0
    var gpa : Float = 0.0
    var coop : Bool = false
    
    init(){
        self.firstname = "NA"
        self.lastname = "NA"
        self.program = "NA"
        self.ccr = 0
        self.gpa = 0.0
        
        if (self.gpa > 3.5){
            self.coop = true
        }else{
            self.coop = false
        }
        
    }
    
    init(firstname: String, lastname: String, program: String, ccr: Int, gpa: Float) {
        
        self.firstname = firstname
        self.lastname = lastname
        self.program = program
        self.ccr = ccr
        self.gpa = gpa
        
        if (self.gpa > 3.5){
            self.coop = true
        }else{
            self.coop = false
        }
    }
    
    //JSON object to Swift Object
    
//    //failable initializer
    init?(dictionary: [String: Any]){
        guard let firstname = dictionary["firstname"] as? String else{
            return nil
        }
        
        guard let lastname = dictionary["lastname"] as? String else{
            return nil
        }
        
        guard let program = dictionary["program"] as? String else{
            return nil
        }
        
        guard let gpa = dictionary["gpa"] as? Float else{
            return nil
        }
        
        guard let ccr = dictionary["ccr"] as? Int else{
            return nil
        }
        
        self.init(firstname: firstname, lastname: lastname, program: program, ccr: ccr, gpa: gpa)
        
    }
}
