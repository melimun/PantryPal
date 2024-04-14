//
//  TempModel.swift
//  PantryPal
//
//  Created by Christian on 2024-04-05.
//
// https://simple-grocery-store-api.glitch.me/products api key

import Foundation



struct TempModel: Identifiable, Codable {
    var id : UUID = UUID()
    var itemId : Int
    var name : String
    var category : String
    var inStock : Bool
    var price : Double
    var manufacturer : String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case category
        case inStock
        case price
        case manufacturer
    }
    
    init(){
        self.itemId = 0
        self.name = ""
        self.category = ""
        self.inStock = false
        self.price = 0.0
        self.manufacturer = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemId = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? "NA"
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? "NA"
        self.inStock = try container.decodeIfPresent(Bool.self, forKey: .inStock) ?? false
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.manufacturer = try container.decodeIfPresent(String.self, forKey: .manufacturer) ?? "NA"
    }
    
}
