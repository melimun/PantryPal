// Melissa Munoz / Eli - 991642239


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
    
    var id: String {
        idMeal
    }
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strMealThumb
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal) ?? "NA"
        self.strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal) ?? "NA"
        self.strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb) ?? "NA"
    }
    
    init(){
        self.idMeal = ""
        self.strMeal = ""
        self.strMealThumb = ""
    }
}
