//
//  RecipeDetails.swift
//  PantryPal
//
//  Created by Eli Munoz on 2024-02-26.
//

import SwiftUI

struct RecipeDetails: View {
    var body: some View {
        
        VStack{
            
            Text("Recipe Name").font(.title).fontWeight(.bold)
            Text("Tags: Breakfast, Balanced, 500 calories").font(.subheadline)
            
            AsyncImage(url: URL(string: "https://placehold.co/500x250/png")).padding()
            VStack{
                
                HStack{
                    
                    
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                        Text("Favourite").foregroundColor(.white)
                    }.tint(.red).buttonStyle(.borderedProminent)
                        .padding([.trailing], 50)
                    
                    Button(action: {
                        //
                    }) {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                        Text("Buy").foregroundColor(.white)
                    }.tint(.blue).buttonStyle(.borderedProminent)
                    
                }
                
                Section(header:Text("Ingredients:").bold()){
                    
                    Text("1 Cabbage")
                    Text("2 Carrots")
                    Text("3 Chicken Legs")
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{Spacer()}
                
                Section(header:Text("Steps:").bold()){
                    
                    Text("Step 1: Prepare the ingredients.")
                    Text("Step 2: Turn on the stovetop to medium heat.")
                    Text("Step 3: (...)")
                }.frame(maxWidth: .infinity, alignment: .leading)
            }//VStack
            .padding()
        }//VStack
        
        Spacer()
    }//body
}//view

#Preview {
    RecipeDetails()
}
