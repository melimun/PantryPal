//
//  Pantry.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-02-10.
//

import SwiftUI
import Photos

struct PantryView: View {
    @State private var selection = 0
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    
    @EnvironmentObject var recipeManager : RecipeManager
    @EnvironmentObject var dbHelper : FireDBHelper

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                List {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: GroceryDetails(item: item, image: "apple.logo")) {
                            ListItem(image: "apple.logo", name: item)
                        }
                    }
                }
                .navigationBarTitle("Pantry List")
                .navigationBarItems(trailing:
                    NavigationLink(destination: NewGroceryView()) {
                        Image(systemName: "plus")
                    }
                )
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Pantry List")
            }
            
            NavigationView {
                
                RecipeView()
                    .environmentObject(recipeManager)
                    .environmentObject(dbHelper)

            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Recipes")
            }
        }
    }
}

struct ListItem: View {
    var image: String
    var name: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            Text(name)
        }
    }
}

