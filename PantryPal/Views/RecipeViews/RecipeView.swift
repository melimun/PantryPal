/* Melissa Munoz */


import SwiftUI

enum Area: String, CaseIterable, Identifiable {
    case American, British, Canadian, French, Mexican, Indian, Italian, Polish, Greek, Jamaican, Chinese, Thai
    var id: Self { self }
}

enum Categories: String, CaseIterable, Identifiable {
    case Breakfast, Dessert, Starter, Vegan, Vegetarian
    var id: Self { self }
}



import SwiftUI

struct RecipeView: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    @EnvironmentObject var dbHelper : FireDBHelper

    
    @State private var selectedArea: Area = .Canadian
    @State private var selectedCategory: Categories = .Vegan
    
    @State private var errorMessage : String = ""
    
    @State private var isPageLoaded = false // Track if the page is loaded
    
    var body: some View {
        
        /* HEADER AND PICKERS */
        
        VStack {
            
            Image("hRecipe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            Section {
                HStack {
                    Spacer()
                    // Picker for Area
                    Picker("Area", selection: $selectedArea) {
                        ForEach(Area.allCases, id: \.self) { area in
                            Text(area.rawValue).tag(area).foregroundColor(.black)
                        }.padding()
                    }.pickerStyle(.menu) .frame(maxWidth: .infinity)
                        .border(Color.gray)
                        .accentColor(.black)
                    
                    // Picker for Dining Type
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Categories.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category).foregroundColor(.black)
                        }.padding()
                    }.pickerStyle(.menu) .frame(maxWidth: .infinity)
                        .border(Color.gray)
                        .accentColor(.black)
                    
                    //Button to submit filter
                    Button(action: {
                        self.filterRecipes()
                    }) {
                        Text("Filter")
                            .font(.caption)
                            .bold()
                            .padding(3)
                            .foregroundColor(.black)
                    }
                    .background(Color(red: 220/255, green: 220/255, blue: 220/255))
                    .padding()
                    
                }//HStack
            }//Section
            
            Spacer()
            /* LIST INFORMATION */
            
            
            if self.recipeManager.filteredRecipeList.meals.isEmpty {
                
                VStack{
                    HStack{
                        Text("Oops!")
                            .font(.title)
                            .bold()
                            .padding()
                    }
                    Text("\(self.errorMessage)")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }.background(.white)
                
                Spacer()
            } else {
                List {
                    ForEach(self.recipeManager.filteredRecipeList.meals) { recipe in
                        NavigationLink(destination: RecipeDetails(recipeID: recipe.idMeal).environmentObject(self.recipeManager)
                            .environmentObject(self.dbHelper)
                        ) {
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
                                    
                                    //Name of recipe
                                    Text("\(recipe.strMeal)").font(.subheadline).fontWeight(.bold)
                                    
                                    //For little pill tags
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8){
                                            ForEach(recipe.strTags?.components(separatedBy: ",") ?? [], id: \.self) { tag in
                                                Text(tag.trimmingCharacters(in: .whitespaces))
                                                    .font(.caption)
                                                    .italic()
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 3)
                                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 193/255,green:221/255,blue:239/255)))
                                                    .lineLimit(1)
                                            }//ForEach
                                        }//HStack
                                    }//Scrollview
                                    
                                    //ingredients
                                    Text("Ingredients:").bold().font(.caption)
                                    Text(recipe.ingredients.map { "\($0.name)" }.joined(separator: ", "))
                                        .font(.caption)
                                        .lineLimit(3)
                                    
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
                    fetchRecipes()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: RecipeFavourites()
                    .environmentObject(dbHelper)
                ) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }//ToolbaritemGroup
        }//toolBar
    }//body
    
    func fetchRecipes() {
        
        //get Recipe by the ingredient list FIRST!
        self.recipeManager.getRecipes()
        
        //This is needed for the page to only load ONCE!
        self.recipeManager.getRecipesById {
            print(#function, "Getting recipes...")
            
            if self.recipeManager.filteredRecipeList.meals.isEmpty {
                self.errorMessage = "We can't seem to find a good recipe with those ingredients!"
                self.isPageLoaded = false
            } else {
                self.errorMessage = ""
                self.isPageLoaded = true
            }
        }
    }//fetchrecipes
    
    func filterRecipes() {
        
        recipeManager.filterRecipesByAreaAndCategory(area: selectedArea.rawValue, category: selectedCategory.rawValue)
        
        if recipeManager.filteredRecipeList.meals.isEmpty {
            self.errorMessage = "No matching results found."
        } else {
            self.errorMessage = ""
        }
        
    }//filterRecipes
    
    
}
