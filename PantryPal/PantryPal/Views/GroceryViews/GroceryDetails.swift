//
//  GroceryDetails.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-03-03.
//

import SwiftUI

struct GroceryDetails: View {
    var item: String
    var image: String
    @State private var name: String = ""
    @State private var datePurchased: String = ""
    @State private var dateSpoil: String = ""
    var body: some View {
        Form {
              Section(header: Text("Grocery Information")) {
                  Image(systemName: image)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 100, height: 100)
                  TextField("Name", text: $name)
                  TextField("Date Purchased", text: $datePurchased)
                  TextField("Expected Spoil Date", text: $dateSpoil)
              }
          }
        .navigationBarTitle(item)
    }
}
