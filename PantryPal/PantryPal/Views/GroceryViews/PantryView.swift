//
//  Pantry.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-02-10.
//

import SwiftUI
import Photos
import FirebaseStorage

struct PantryView: View {
    @State private var selection = 0
    @State private var items = [UIImage]()
    
    @EnvironmentObject var recipeManager : RecipeManager
    @EnvironmentObject var dbHelper : FireDBHelper

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                List {
                    /*
                    ForEach(self.dbHelper.ingredientList.enumerated().map({$0}), id: \.element.self) {index, item in
                        NavigationLink {
                            GroceryDetails(selectedIngredientIndex : index).environmentObject(self.dbHelper)
                        }label: {
                            ListItem(image: item.ingredientImage, name: item.ingredientName)
                        }//NavigationLink
                    }
                    */
                     ForEach(self.dbHelper.retrievedImages, id: \.self) { image in
                         NavigationLink {
                             GroceryDetails().environmentObject(self.dbHelper)
                         }label: {
                             Image(uiImage : image)
                                 .resizable()
                                 .frame(width: 100, height: 100)
                         }//NavigationLink
                     }
                    .onDelete(){indexSet in
                        for index in indexSet{
                            print(#function, "Trying to delete ingredient : \(self.dbHelper.ingredientList[index].ingredientName)")
                            
                            //delete the ingredient from database
                            self.dbHelper.deleteIngredient(docIDtoDelete : self.dbHelper.ingredientList[index].id!)
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
        .onAppear(){
            //get all Ingredients from database
            //self.dbHelper.retrieveAllIngredients()
            self.dbHelper.retrieveImages()
        }//onAppear
    }
}

struct ListItem: View {
    var image: String
    var name: String
    
    var body: some View {
        HStack {
            Image(systemName: "apple.logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            Text(name)
        }
    }
}

