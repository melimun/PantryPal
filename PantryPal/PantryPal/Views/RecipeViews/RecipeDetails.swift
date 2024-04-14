import SwiftUI

struct RecipeDetails: View {
    
    @EnvironmentObject private var recipeManager: RecipeManager
    @State var recipeID: String
    @State private var isFavorited = false
    @EnvironmentObject var dbHelper : FireDBHelper
    @EnvironmentObject var itemManager : ItemManager

    
    var body: some View {
        NavigationStack{
            ScrollView{
                if let recipe = self.recipeManager.filteredRecipeList.meals.first(where: { $0.idMeal == recipeID }) {
                    VStack{
                        AsyncImage(
                            url: URL(string:recipe.strMealThumb),
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(10)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        
                        VStack{
                            Spacer()
                            //Title
                            Text("\(recipe.strMeal)").font(.title).fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            
                            //Tags
                            Text("Tags: \(recipe.strTags ?? "Tag missing"), \(recipe.strArea ?? "Area missing"), \(recipe.strCategory ?? "Category missing")").font(.subheadline)
                            
                            HStack{
                                if let sourceURLString1 = recipe.strYoutube, let sourceURL1 = URL(string: sourceURLString1) {
                                    Link("Youtube Tutorial", destination: sourceURL1)
                                } else {
                                    Text("No Link Available")
                                }
                                Text(" | ")
                                
                                if let sourceURLString2 = recipe.strSource, let sourceURL2 = URL(string: sourceURLString2) {
                                    Link("Original Source", destination: sourceURL2)
                                } else {
                                    Text("No Link Available")
                                }
                            }//HStack
                            
                            Spacer()
                            HStack{
                                
                                //* Buttons *//
                                
                                Button(action: {
                                                    //Favourite
                                    self.favouriteRecipe(recipe: recipe)
                                                }) {
                                                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                                                        .foregroundColor(isFavorited ? .white : .white)
                                                    Text("Favourite").foregroundColor(.white)
                                                }
                                                .tint(.red).buttonStyle(.borderedProminent)
                                                .padding([.trailing], 50)
                                NavigationLink{
                                    ItemListView().environmentObject(self.dbHelper).environmentObject(self.itemManager)
                                } label: {
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.black)
                                    Text("Buy").foregroundColor(.black)
                                }
                               
                    
                                
                                }
                                
                            
                            //Ingredients
                            Section(header: Text("Ingredients:\n").bold()) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    HStack{
                                        Text("\(ingredient.name)")
                                            .font(.subheadline).bold()
                                        Text("- \(ingredient.measure)")
                                            .font(.subheadline)
                                    }
                                }
                            }.padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack{Spacer()}
                            
                            //Recipes
                            Section(header:Text("Steps:").bold()){
                                Text(recipe.strInstructions?.replacingOccurrences(of: ".", with: ".\n\n") ?? "No Instructions")
                                    .font(.subheadline)
                            }.padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                        }//VStack
                        .background(Color(.white))
                        .cornerRadius(20)
                        .padding()
                    }//VStack
                    .background(Color(red:239/255,green:239/255,blue:239/255))
                } else {
                    VStack {
                        Text("Recipe not found")
                            .font(.headline)
                            .bold()
                            .padding()
                        Text("Sorry, the recipe with ID \(recipeID) could not be found.")
                            .font(.caption)
                    }
                }
            }//ScrollView
        }
       
        
    }//body
    
    func favouriteRecipe(recipe: Recipe) {
        print(#function, "Favourite recipe function called")
        
        self.isFavorited.toggle()
        
        print(#function, "Attempting to add recipe to firebase...")
        
        let newRecipe = RecipeFirebase(
            id: nil,
            idMeal: recipe.idMeal,
            strMeal: recipe.strMeal,
            strMealThumb: recipe.strMealThumb,
            strArea: recipe.strArea ?? "",
            strCategory: recipe.strCategory ?? "",
            strInstructions: recipe.strInstructions ?? "",
            strTags: recipe.strTags ?? "",
            strYoutube: recipe.strYoutube ?? "",
            strSource: recipe.strSource ?? "",
            strImageSource: recipe.strImageSource ?? "",
            strCreativeCommonsConfirmed: recipe.strCreativeCommonsConfirmed ?? "",
            dateModified: recipe.dateModified ?? "",
            ingredients: recipe.ingredients.map { $0.name }
        )
        
        self.dbHelper.insertRecipe(recipe: newRecipe)
        
        print(#function, "Recipe added to Firebase")
        
        withAnimation(.spring()) {
            //No customizations for animation
        }
    }

    
}//view
