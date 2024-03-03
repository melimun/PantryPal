// Melissa Munoz / Eli - 991642239


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


struct RecipeView: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    
    
    @State private var selectedDiet: Diet = .Balanced
    @State private var selectedDining: DiningType = .Breakfast
    @State private var selectedCalories: Calories = .Under200
    
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: "https://placehold.co/600x150/png"))
            Section{
                
                HStack{
                    //Picker for Diet
                    
                    Picker("Diet", selection: $selectedDiet) {
                        
                        Text("Balanced").tag(Diet.Balanced)
                        Text("Dairy-Free").tag(Diet.DairyFree)
                        Text("Gluten-Free").tag(Diet.GlutenFree)
                        Text("High-Fiber").tag(Diet.HighFiber)
                        Text("High-Protein").tag(Diet.HighProtein)
                        Text("Low Carb").tag(Diet.LowCarb)
                        Text("Low Fat").tag(Diet.LowFat)
                        Text("Low Sodium").tag(Diet.LowSodium)
                        Text("Low Sugar").tag(Diet.LowSugar)
                        Text("Vegan").tag(Diet.Vegan)
                        Text("Vegetarian").tag(Diet.Vegetarian)
                    }.pickerStyle(.menu)
                    
                    //Picker for Dining Type
                    Picker("Dining Type", selection: $selectedDining) {
                        Text("Breakfast").tag(DiningType.Breakfast)
                        Text("Lunch").tag(DiningType.Lunch)
                        Text("Dinner").tag(DiningType.Dinner)
                        Text("Snack").tag(DiningType.Snack)
                    }.pickerStyle(.menu)
                    
                    //Picker for Calories
                    Picker("Calories", selection: $selectedCalories) {
                        Text("Under 200").tag(Calories.Under200)
                        Text("200-400").tag(Calories.Btwn200400)
                        Text("400-600").tag(Calories.Betwn400600)
                        Text("Above 600").tag(Calories.Above600)
                    }.pickerStyle(.menu)
                }//HStack
            }//Section
            
            if self.recipeManager.recipeList.isEmpty {
                VStack{
                    HStack{
                        
                        ProgressView()
                            .controlSize(.large)
                        Text("Loading...")
                            .font(.headline)
                            .bold()
                            .padding()
                        
                    }
                    Text("Consulting our chefs")
                        .font(.caption)
                }.background(.white)
                
            } else {
                VStack{
                    
                    
                    Section{
                        
                    }//Section
                }
                
                
                List {
                    
                    ForEach(self.recipeManager.recipeList.indices, id: \.self) { recipeIndex in
                        let recipe = self.recipeManager.recipeList[recipeIndex]
                        
                        NavigationLink(
                            destination: RecipeDetails()
                        ) {
                            
                            HStack{
                                
                                AsyncImage(url: URL(string: "https://placehold.co/100x100/png"))
                                
                                
                                VStack {
                                    
                                    //Content of recipes
                                    Text("Recipe Name").fontWeight(.bold).lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("3/4 stars").font(.subheadline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Ingredients").font(.caption).lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Description will be located here. Giving a preview of the steps.").font(.caption).lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                }//VStack
                                
                            }//HStack
                        }//NavLink
                    }//ForEach
                }//List
                .listStyle(.insetGrouped)
                .listRowSeparator(.visible)
            }//if-else
        }//Vstack
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
        .clipped()
        .onAppear() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.recipeManager.getBooks()
                
            }
        }//onAppear
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                
                NavigationLink(destination: RecipeFavourites()){
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }//ToolbaritemGroup
        }//toolBar
    }//body
}

#Preview {
    RecipeView()
}
