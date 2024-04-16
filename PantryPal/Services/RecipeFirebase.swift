//
//  RecipeFirebase.swift
//  PantryPal
//
//  Created by Eli Munoz on 2024-04-11.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct RecipeFirebase: Codable, Hashable {
    
    @DocumentID var id: String?
    
    var idMeal : String
    var strMeal: String
    var strMealThumb: String
    
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strTags: String?
    var strYoutube: String
    var strSource: String
    var strImageSource: String
    var strCreativeCommonsConfirmed: String
    var dateModified: String

    var ingredients: [String]?
    
    init(id: String?, idMeal: String, strMeal: String, strMealThumb: String, strArea: String, strCategory: String, strInstructions: String, strTags : String?, strYoutube : String, strSource : String, strImageSource : String, strCreativeCommonsConfirmed : String, dateModified : String, ingredients : [String]?) {
        self.id = id ?? UUID().uuidString
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strCategory = strCategory
        self.strMealThumb = strMealThumb
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strTags = strTags ?? "N/A"
        self.strYoutube = strYoutube
        self.strSource = strSource
        self.strImageSource = strImageSource
        self.strCreativeCommonsConfirmed = strCreativeCommonsConfirmed
        self.dateModified = dateModified
        self.ingredients = ingredients ?? []
    }
    
    
    // Initialize from a dictionary
    // Initialize from a dictionary
    init?(dictionary: [String: Any]) {
        guard let strMeal = dictionary["strMeal"] as? String,
              let strMealThumb = dictionary["strMealThumb"] as? String,
              let idMeal = dictionary["idMeal"] as? String,
              let strCategory = dictionary["strCategory"] as? String,
              let strArea = dictionary["strArea"] as? String,
              let strInstructions = dictionary["strInstructions"] as? String,
              let strTags = dictionary["strTags"] as? String,
              let strYoutube = dictionary["strYoutube"] as? String,
              let strSource = dictionary["strSource"] as? String,
              let strImageSource = dictionary["strImageSource"] as? String,
              let strCreativeCommonsConfirmed = dictionary["strCreativeCommonsConfirmed"] as? String,
              let dateModified = dictionary["dateModified"] as? String
        else {
            return nil
        }
        
        self.init(id: nil, idMeal: idMeal,
                  strMeal: strMeal,
                  strMealThumb: strMealThumb,
                  strArea: strArea, strCategory: strCategory,
                  strInstructions: strInstructions,
                  strTags: strTags,
                  strYoutube: strYoutube,
                  strSource: strSource,
                  strImageSource: strImageSource,
                  strCreativeCommonsConfirmed: strCreativeCommonsConfirmed,
                  dateModified: dateModified,
                  ingredients: dictionary["ingredients"] as? [String])
    }
    
    // Convert to a dictionary for Firestore
    func toDictionary() -> [String: Any] {
            var dictionary: [String: Any] = [
                "idMeal" : idMeal,
                "strMeal": strMeal,
                "strMealThumb": strMealThumb,
                "strCategory": strCategory,
                "strArea": strArea,
                "strInstructions": strInstructions,
                "strTags": strTags ?? "N/A",
                "strYoutube": strYoutube,
                "strSource": strSource,
                "strImageSource": strImageSource,
                "strCreativeCommonsConfirmed": strCreativeCommonsConfirmed,
                "dateModified": dateModified
            ]

            if let ingredients = ingredients {
                dictionary["ingredients"] = ingredients
            }

            return dictionary
        }
}
