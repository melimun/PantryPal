//
//  RecipeFavourites.swift
//  PantryPal
//
//  Created by Eli Munoz on 2024-02-27.
//

import SwiftUI

struct RecipeFavourites: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    @EnvironmentObject var dbHelper : FireDBHelper

    
    var body: some View {
        
        /* HEADER AND PICKERS */
        
        VStack {
            
            Image("fRecipe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            
            Spacer()
            /* LIST INFORMATION */
            
            
            //* To DO: Replace this with firebase data *//
            //            if self.recipeManager.filteredRecipeList.meals.isEmpty {
            
            VStack{
                HStack{
                    Text("Oops!")
                        .font(.title)
                        .bold()
                        .padding()
                }
                Text("It looks like you didn't favourite anything!")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }.background(.white)
                .navigationTitle("Favourites")
            
            Spacer()
            //            } else {
            //                List {
            //                    ForEach(self.recipeManager.filteredRecipeList.meals) { recipe in
            //                        NavigationLink(destination: RecipeDetails(recipeID: recipe.idMeal).environmentObject(self.recipeManager)) {
            //                            HStack {
            //                                AsyncImage(
            //                                    url: URL(string: recipe.strMealThumb),
            //                                    content: { image in
            //                                        image.resizable()
            //                                            .aspectRatio(contentMode: .fit)
            //                                            .frame(maxWidth: 300, maxHeight: 100)
            //                                            .cornerRadius(10)
            //                                    },
            //                                    placeholder: {
            //                                        ProgressView()
            //                                    }
            //                                )
            //                                
            //                                VStack(alignment: .leading) {
            //                                    
            //                                    //Name of recipe
            //                                    Text("\(recipe.strMeal)").font(.subheadline).fontWeight(.bold)
            //                                    
            //                                    //For little pill tags
            //                                    ScrollView(.horizontal, showsIndicators: false) {
            //                                        HStack(spacing: 8){
            //                                            ForEach(recipe.strTags?.components(separatedBy: ",") ?? [], id: \.self) { tag in
            //                                                Text(tag.trimmingCharacters(in: .whitespaces))
            //                                                    .font(.caption)
            //                                                    .italic()
            //                                                    .padding(.horizontal, 8)
            //                                                    .padding(.vertical, 3)
            //                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 193/255,green:221/255,blue:239/255)))
            //                                                    .lineLimit(1)
            //                                            }//ForEach
            //                                        }//HStack
            //                                    }//Scrollview
            //                                    
            //                                    //ingredients
            //                                    Text("Ingredients:").bold().font(.caption)
            //                                    Text(recipe.ingredients.map { "\($0.name)" }.joined(separator: ", "))
            //                                        .font(.caption)
            //                                        .lineLimit(3)
            //                                    
            //                                }//VStack
            //                            }//HStack
            //                        }//NavLink
            //                    }//ForEach
            //                }//List
            //                .listStyle(.insetGrouped)
            //                .listRowSeparator(.visible)
            //            }//if-else
            //        }//VStack
            //        .navigationTitle("Recipes")
            //        .navigationBarTitleDisplayMode(.inline)
            //        .background(.white)
            //        .onAppear {
            //            if !isPageLoaded {
            //                fetchRecipes()
            //            }
            //        }
            //        .toolbar {
            //            ToolbarItemGroup(placement: .navigationBarTrailing) {
            //                Button(action: {
            //                    // Refresh button action
            //                    fetchRecipes()
            //                }) {
            //                    Image(systemName: "arrow.clockwise")
            //                        .foregroundColor(.blue)
            //                }
            //                NavigationLink(destination: RecipeFavourites()) {
            //                    Image(systemName: "heart.fill")
            //                        .foregroundColor(.red)
            //                }
            //            }//ToolbaritemGroup
            //        }//toolBar
        }//body
        
        //    func fetchRecipes() {
        //        
        //        self.recipeManager.getRecipes()
        //        self.recipeManager.getRecipesById {
        //            print(#function, "Getting recipes...")
        //            
        //            if self.recipeManager.filteredRecipeList.meals.isEmpty {
        //                self.errorMessage = "We can't seem to find a good recipe with those ingredients!"
        //                self.isPageLoaded = false
        //            } else {
        //                self.errorMessage = ""
        //                self.isPageLoaded = true
        //            }
        //        }
        //    }//fetchrecipes
        
    }
}
