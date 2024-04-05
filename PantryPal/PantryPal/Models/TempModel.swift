//
//  TempModel.swift
//  PantryPal
//
//  Created by Christian on 2024-04-05.
//
// https://simple-grocery-store-api.glitch.me/products api key

import Foundation

struct TempModel: Identifiable, Decodable {
    var id : UUID = UUID()
    var name : String
    var category : String
    var inStock : Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case category
        case inStock
    }
    
    init(){
        self.name = ""
        self.category = ""
        self.inStock = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "NA"
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "NA"
        self.inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock) ?? false
    }
    
}
