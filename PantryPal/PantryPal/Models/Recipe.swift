

import Foundation
import UIKit

struct RecipeResponse: Codable {
    let meals: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case meals
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meals = try container.decodeIfPresent([Recipe].self, forKey: .meals) ?? [Recipe]()
    }
    
    init(){
        self.meals = []
    }
}

struct Recipe: Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    let strCategory: String?
    let strArea: String?
    let strInstructions: String?
    let strTags: String?
    let strYoutube: String?
    let strSource: String?
    let strImageSource: String?
    let strCreativeCommonsConfirmed: String?
    let dateModified: String?
    
    let ingredients: [FoodItem]
    
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    
    var id: String {
        idMeal
    }
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
        case strCategory, strArea, strInstructions, strTags, strYoutube, strSource, strImageSource, strCreativeCommonsConfirmed, dateModified
        
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //For get by Ingredients
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal) ?? "NA"
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal) ?? "NA"
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb) ?? "NA"
        
        //For get Recipe Details by ID
        self.strCategory = try container.decodeIfPresent(String.self, forKey: .strCategory)
        self.strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        self.strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        self.strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)
        self.strSource = try container.decodeIfPresent(String.self, forKey: .strSource)
        self.strImageSource = try container.decodeIfPresent(String.self, forKey: .strImageSource)
        self.strCreativeCommonsConfirmed = try container.decodeIfPresent(String.self, forKey: .strCreativeCommonsConfirmed)
        self.dateModified = try container.decodeIfPresent(String.self, forKey: .dateModified)
        
        
        //ingredients
        // Initialize ingredients array
        var ingredients: [FoodItem] = []
        
        // Loop over ingredient keys and append non-empty values to the ingredients array
        for index in 1...20 {
            if let ingredientKey = CodingKeys(rawValue: "strIngredient\(index)"),
               let measurementKey = CodingKeys(rawValue: "strMeasure\(index)"),
               let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey),
               let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey),
               !ingredient.isEmpty, !measurement.isEmpty {
                ingredients.append(FoodItem(name: ingredient,measure: measurement))
            }
        }
        
        self.ingredients = ingredients
    }
    
    init(){
        self.idMeal = ""
        self.strMeal = ""
        self.strMealThumb = ""
        self.strCategory = ""
        self.strArea = ""
        self.strInstructions = ""
        self.strTags = ""
        self.strYoutube = ""
        self.strSource = ""
        self.strImageSource = ""
        self.strCreativeCommonsConfirmed = ""
        self.dateModified = ""
        self.ingredients = [FoodItem]()
    }
}

struct FoodItem: Codable, Hashable {
    let name: String
    let measure: String
    
    init(name: String, measure: String) {
        self.name = name
        self.measure = measure
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case measure
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "NA"
        self.measure = try container.decodeIfPresent(String.self, forKey: .measure) ?? "NA"
    }
    
    init(){
        self.name = ""
        self.measure = ""
    }
}
