

import SwiftUI

enum Area: String, CaseIterable, Identifiable {
    case American, British, Canadian, French, Mexican, Indian, Italian, Polish, Greek
    var id: Self { self }
}

enum Categories: String, CaseIterable, Identifiable {
    case Vegan, Vegetarian
    var id: Self { self }
}



import SwiftUI

struct RecipeView: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    
    @State private var selectedArea: Area = .Canadian
    @State private var selectedCategory: Categories = .Vegan

    @State private var isPageLoaded = false // Track if the page is loaded
    
    var body: some View {
        VStack {
            
            Image("header")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
            
            Section {
                HStack {
                    // Picker for Diet
                    Picker("Area", selection: $selectedArea) {
                        ForEach(Area.allCases, id: \.self) { area in
                            Text(area.rawValue).tag(area)
                        }
                    }.pickerStyle(.menu)
                    
                    // Picker for Dining Type
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Categories.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }.pickerStyle(.menu)
                    
                    
                }//HStack
            }//Section
            
            if self.recipeManager.filteredRecipeList.meals.isEmpty {
                VStack{
                    HStack{
                        Text("Sorry :(")
                            .font(.headline)
                            .bold()
                            .padding()
                    }
                    Text("We can't find any recipes that fit your criteria.")
                        .font(.caption)
                }.background(.white)
            } else {
                List {
                    ForEach(self.recipeManager.filteredRecipeList.meals) { recipe in
                        NavigationLink(destination: RecipeDetails(recipeID: recipe.idMeal).environmentObject(self.recipeManager)) {
                            HStack {
                                AsyncImage(
                                    url: URL(string: recipe.strMealThumb),
                                    content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 300, maxHeight: 100)
                                            .cornerRadius(10)
                                    },
                                    placeholder: {
                                        ProgressView()
                                    }
                                )
                                
                                VStack(alignment: .leading) {
                                    
                                    Text("\(recipe.strMeal)").font(.subheadline).fontWeight(.bold)
                                    Text("Tags:").bold().font(.caption)
                                    Text("\(recipe.strTags ?? "No tags")").font(.caption).lineLimit(1).italic()
                                    if recipe.ingredients != nil {
                                        // Ingredients
                                        Text("Ingredients:").bold().font(.caption)
                                        Text(recipe.ingredients.map { "\($0.name)" }.joined(separator: ", "))
                                            .font(.caption)
                                            .lineLimit(3)
                                    }
                                    
                                }//VStack
                            }//HStack
                        }//NavLink
                    }//ForEach
                }//List
                .listStyle(.insetGrouped)
                .listRowSeparator(.visible)
            }//if-else
        }//VStack
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
        .onAppear {
            if !isPageLoaded {
                fetchRecipes()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    // Refresh button action
                    fetchRecipes()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: RecipeFavourites()) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }//ToolbaritemGroup
        }//toolBar
    }//body
    
    func fetchRecipes() {
        
        let area = selectedArea.rawValue.lowercased()
        let category = selectedCategory.rawValue.lowercased()
        
        self.recipeManager.getRecipes()
        self.recipeManager.getRecipesById {
            print(#function, "Getting recipes...")
            
            if self.recipeManager.filteredRecipeList.meals.isEmpty {
                self.isPageLoaded = false
            } else {
                self.isPageLoaded = true
            }
        }
    }
}
