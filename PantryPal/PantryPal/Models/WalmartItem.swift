//
//  WalmartItem.swift
//  PantryPal
//
//  Created by Christian on 2024-04-03.
//

import Foundation

struct WalmartItem: Identifiable, Decodable {
    var id : UUID = UUID()
    let uri : String
    let label : String
    let images : [WalmartImage]
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
        self.images = try container.decodeIfPresent([WalmartImage].self, forKey: .images) ?? []
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? "NA"
        self.dietLabels = try container.decodeIfPresent([String].self, forKey: .dietLabels) ?? []
        self.healthLabels = try container.decodeIfPresent([String].self, forKey: .healthLabels) ?? []
        self.ingredients = try container.decodeIfPresent([Ingredients].self, forKey: .ingredients) ?? []
        self.calories = try container.decodeIfPresent(Int.self, forKey: .calories) ?? 0
    }
    
}//Struct

struct WalmartImage : Decodable{
    let THUMBNAIL : String
    let SMALL : String //will depend on api structure
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
