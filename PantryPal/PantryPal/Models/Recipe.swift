// Melissa Munoz / Eli - 991642239


import Foundation
import UIKit

struct Response: Decodable {
    let hits: [Hit]
    
    init(){
        self.hits = []
    }
    
    enum CodingKeys: String, CodingKey {
        case hits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hits = try container.decodeIfPresent([Hit].self, forKey: .hits) ?? [Hit()]
    }
    
}

struct Hit: Decodable {
    let recipe: Recipe
    
    init(){
        self.recipe = Recipe()
    }
    
    enum CodingKeys: String, CodingKey {
        case recipe
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipe = try container.decodeIfPresent(Recipe.self, forKey: .recipe) ?? Recipe()
    }
    
}

struct Recipe: Identifiable, Decodable {
    var id : UUID = UUID()
    let uri : String
    let label : String
    let images : [RecipeImage]
    let url : String
    let dietLabels : [String]
    let healthLabels: [String]
    let ingredients : [Ingredients]
    let calories : Int
    
    enum CodingKeys: String, CodingKey {
        case uri
        case label
        case images
        case url
        case dietLabels
        case healthLabels
        case ingredients
        case calories
    }//codingKeys
    
    init(){
        self.uri = ""
        self.label = ""
        self.images = []
        self.url = ""
        self.dietLabels = []
        self.healthLabels = []
        self.ingredients = []
        self.calories = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decodeIfPresent(String.self, forKey: .uri) ?? "NA"
        self.label = try container.decodeIfPresent(String.self, forKey: .label) ?? "NA"
        self.images = try container.decodeIfPresent([RecipeImage].self, forKey: .images) ?? []
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? "NA"
        self.dietLabels = try container.decodeIfPresent([String].self, forKey: .dietLabels) ?? []
        self.healthLabels = try container.decodeIfPresent([String].self, forKey: .healthLabels) ?? []
        self.ingredients = try container.decodeIfPresent([Ingredients].self, forKey: .ingredients) ?? []
        self.calories = try container.decodeIfPresent(Int.self, forKey: .calories) ?? 0
    }
    
}//Struct

struct RecipeImage : Decodable{
    let THUMBNAIL : String
    let SMALL : String
    let REGULAR : String
    let LARGE : String
    
    enum CodingKeys: String, CodingKey {
        case THUMBNAIL
        case SMALL
        case REGULAR
        case LARGE
    }//codingKeys
    
    init(){
        self.THUMBNAIL = ""
        self.SMALL = ""
        self.REGULAR = ""
        self.LARGE = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.THUMBNAIL = try container.decodeIfPresent(String.self, forKey: .THUMBNAIL) ?? "NA"
        self.SMALL = try container.decodeIfPresent(String.self, forKey: .SMALL) ?? "NA"
        self.REGULAR = try container.decodeIfPresent(String.self, forKey: .REGULAR) ?? "NA"
        self.LARGE = try container.decodeIfPresent(String.self, forKey: .LARGE) ?? "NA"

    }
    
}

struct Ingredients : Decodable{
    let text : String
    let quantity : Int
    let measure : String
    let food : String
    let weight : Int
    let foodId: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case quantity
        case measure
        case food
        case weight
        case foodId
    }
    
    init(){
        self.text = ""
        self.quantity = 0
        self.measure = ""
        self.food = ""
        self.weight = 0
        self.foodId = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? "NA"
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        self.measure = try container.decodeIfPresent(String.self, forKey: .measure) ?? "NA"
        self.food = try container.decodeIfPresent(String.self, forKey: .food) ?? "NA"
        self.weight = try container.decodeIfPresent(Int.self, forKey: .weight) ?? 0
        self.foodId = try container.decodeIfPresent(String.self, forKey: .foodId) ?? "NA"
    }
    
    
}
