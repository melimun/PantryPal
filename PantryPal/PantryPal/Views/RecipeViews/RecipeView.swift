

import SwiftUI

enum Diet: String, CaseIterable, Identifiable {
    case Balanced,
         DairyFree,
         GlutenFree,
         HighFiber,
         HighProtein,
         LowCarb,
         LowFat,
         LowSodium,
         LowSugar,
         Vegan,
         Vegetarian
    var id: Self { self }
}

enum DiningType: String, CaseIterable, Identifiable {
    case Breakfast, Lunch, Dinner, Snack
    var id: Self { self }
}

enum Calories: String, CaseIterable, Identifiable {
    case Under200,Btwn200400,Betwn400600,Above600
    var id: Self { self }
}


import SwiftUI

struct RecipeView: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    
    @State private var selectedDiet: Diet = .Balanced
    @State private var selectedDining: DiningType = .Breakfast
    @State private var selectedCalories: Calories = .Under200
    @State private var isPageLoaded = false // Track if the page is loaded
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://placehold.co/600x150/png"))
            Section {
                HStack {
                    // Picker for Diet
                    Picker("Diet", selection: $selectedDiet) {
                        ForEach(Diet.allCases, id: \.self) { diet in
                            Text(diet.rawValue).tag(diet)
                        }
                    }.pickerStyle(.menu)
                    
                    // Picker for Dining Type
                    Picker("Dining Type", selection: $selectedDining) {
                        ForEach(DiningType.allCases, id: \.self) { diningType in
                            Text(diningType.rawValue).tag(diningType)
                        }
                    }.pickerStyle(.menu)
                    
                    // Picker for Calories
                    Picker("Calories", selection: $selectedCalories) {
                        ForEach(Calories.allCases, id: \.self) { calories in
                            Text(calories.rawValue).tag(calories)
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
                                        Text(recipe.ingredients.map { "\($0.name)" }.joined(separator: ", ") ?? "No Ingredients")
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
        .clipped()
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
