

import SwiftUI

struct RecipeFavourites: View {
    
    @EnvironmentObject var recipeManager: RecipeManager
    @EnvironmentObject var dbHelper : FireDBHelper
    
    @State private var isfavouritesLoaded = false

    
    var body: some View {
        
        /* HEADER AND PICKERS */
        
        VStack {
            
            Image("fRecipe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            
            Spacer()
            /* LIST INFORMATION */
            
            
            
            if self.dbHelper.favouriteList.isEmpty {
                
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
            } else {
                List {
                    ForEach(self.dbHelper.favouriteList, id: \.id.self) { recipe in
                        
                        NavigationLink{
                            
                            RecipeDetails(recipeID: recipe.idMeal)
                                .environmentObject(self.recipeManager)
                            
                        }label:{
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
                                    // Ingredients
                                    Text("Ingredients:")
                                        .bold()
                                        .font(.caption)
                                    
                                    if let ingredients = recipe.ingredients {
                                        Text(ingredients.map { $0 }.joined(separator: ", "))
                                            .font(.caption)
                                            .lineLimit(3)
                                    }

                                    
                                   
    
                                    
                                }//VStack
                            }//HStack
                        }//NavLink
                    }//ForEach
                    .onDelete(){
                        indexSet in
                        for index in indexSet{
                            
                            //delete the student from database
                            self.dbHelper.deleteRecipe(docIDtoDelete: self.dbHelper.favouriteList[index].id!)
                        }
                    }
                }//List
                .listStyle(.insetGrouped)
                .listRowSeparator(.visible)
            }//if-else
        }//VStack
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
        .onAppear {
            if self.dbHelper.favouriteList.isEmpty {
                self.dbHelper.retrieveAllRecipes()
            }
        }
        
    }//body
    
}
