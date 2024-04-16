//
//  GroceryDetails.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-03-03.
//

import SwiftUI

struct GroceryDetails: View {
    
    @EnvironmentObject var dbHelper : FireDBHelper
    @Environment(\.dismiss) var dismiss
    
    //var selectedIngredientIndex : Int = -1
    
    //var image: String
    
    @ObservedObject var mlHelper = MLHelper()
    
    @EnvironmentObject var stHelper : FireStorageHelper
    
    @State private var permissionGranted : Bool = false
    @State private var showSheet : Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    @State private var profileImage : UIImage?
    
    //@State private var item: String = ""
    @State private var name: String = ""
    @State private var datePurchased: String = ""
    @State private var dateSpoil: String = ""
    @State private var price: String = ""
     
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: (profileImage ?? UIImage(systemName: "plus.app"))!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
            }
            
            Spacer()
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Date Purchased", text: $datePurchased)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Expected Spoil Date", text: $dateSpoil)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Price", text: $price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Action for cancel button
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(20)
                }
                .padding()
                Spacer()
                Button(action: {
                    
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .padding()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }//VStack
        .navigationTitle("Update Item")
        .padding()
        /*.onAppear {
            self.name = self.dbHelper.ingredientList[selectedIngredientIndex].ingredientName ?? "NA"
            self.datePurchased = self.dbHelper.ingredientList[selectedIngredientIndex].purchaseDate ?? "NA"
            self.dateSpoil = self.dbHelper.ingredientList[selectedIngredientIndex].expirationDate ?? "NA"
            self.price = "\(self.dbHelper.ingredientList[selectedIngredientIndex].price)"
        }*/
    }//body
}
