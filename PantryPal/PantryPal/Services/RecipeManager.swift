import Foundation

class RecipeManager: ObservableObject {
    
    @Published var recipeList = RecipeResponse() //Get recipes that have those ingredients
    @Published var filteredRecipeList = RecipeResponse() //Get recipes that fit the certain ID
    @Published var recipeIDs = [String]() //string of IDs
    
    @Published var ingredientList = ["chicken"] //ingredientTest
    
    
    func byIngredientsURL(specification: String) -> String {
        let encodedIngredients = specification.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "https://www.themealdb.com/api/json/v2/9973533/filter.php?i=\(encodedIngredients)"
    }
    
    func byRecipeIDURL(id: String) -> String {
        return "https://www.themealdb.com/api/json/v2/9973533/lookup.php?i=\(id)"
    }
    
    func getRecipes() {
        guard let apiURL = URL(string: byIngredientsURL(specification: ingredientList.joined(separator: ","))) else {
            return
        }

        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error fetching recipes")
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedRecipe = try decoder.decode(RecipeResponse.self, from: data)

                DispatchQueue.main.async {
                    self.recipeList = decodedRecipe
                    self.recipeIDs = decodedRecipe.meals.map { $0.idMeal }
                }
            } catch {
                print("Error decoding recipes: \(error)")
            }
        }.resume()
    }
    
    func resetLists() {
        recipeIDs.removeAll()
        recipeList = RecipeResponse()
        filteredRecipeList = RecipeResponse()
    }
    
    func getRecipesById(completion: @escaping () -> Void) {
        var filteredRecipeLists = RecipeResponse()
        let dispatchGroup = DispatchGroup()
        
        for id in recipeIDs {
            dispatchGroup.enter()
            
            guard let apiURL = URL(string: byRecipeIDURL(id: id)) else {
                dispatchGroup.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: apiURL) { data, response, error in
                defer {
                    dispatchGroup.leave()
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Error fetching recipe with ID: \(id)")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedRecipe = try decoder.decode(RecipeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        filteredRecipeLists.meals.append(contentsOf: decodedRecipe.meals)
                    }
                } catch {
                    print("Error decoding recipe with ID: \(id)")
                }
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.filteredRecipeList = filteredRecipeLists
            completion()
        }
    }
}
