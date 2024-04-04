import SwiftUI

struct RecipeDetails: View {
    
    @EnvironmentObject private var recipeManager: RecipeManager
    @State var recipeID: String
    
    var body: some View {
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
                            Button(action: {
                                //Favourite
                            }) {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                Text("Favourite").foregroundColor(.white)
                            }.tint(.red).buttonStyle(.borderedProminent)
                                .padding([.trailing], 50)
                            
                            Button(action: {
                                //Buy Ingredients
                            }) {
                                Image(systemName: "cart.fill")
                                    .foregroundColor(.white)
                                Text("Buy").foregroundColor(.white)
                            }.tint(.blue).buttonStyle(.borderedProminent)
                        }.padding()
                        
                        //Ingredients
                        Section(header: Text("Ingredients:").bold()) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text("\(ingredient.name) - \(ingredient.measure)")
                                    .font(.subheadline)
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
                .background(Color(.gray))
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
}
