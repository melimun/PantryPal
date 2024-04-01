// Melissa Munoz / Eli - 991642239

import Foundation
import UIKit

class RecipeManager : ObservableObject{
    
    @Published var recipeList = RecipeResponse()
    @Published var recipe = RecipeResponse()
    @Published var ingredientList = ["chicken"]

    func byRandomRecipeURL() -> String{
        
        let baseURL = "www.themealdb.com/api/json/v2/9973533/randomselection.php"
        
        return baseURL
    }
    
    func byIngredientsURL(specification:String) -> String{
        
        //This gets recipes by ingredients
        let baseURL = "https://www.themealdb.com/api/json/v2/9973533/filter.php?i="+specification
        
        return baseURL
    }
    
    func byRecipeIDURL(id:String) -> String{
        
        //This gets recipe details by ID
        let baseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="+id
        
        return baseURL
    }


    //* gets recipes from ingredients *//
    
    func getRecipes(){
        
        print("GetRecipes() Fetching data from API called")
                
        guard let apiURL = URL(string: byIngredientsURL(specification: ingredientList.joined(separator: ","))) else{
            return
        }
        
        print(#function, "apiURL = \(apiURL)\n")
    
        
        let task = URLSession.shared.dataTask(with: apiURL){
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let err = error {
                
                print(#function, "Unable to connect to the web service :\(err)")
                
                return
            }else{
                
                print(#function, "Connected to web service\n")
                
                if let httpResponse = response as? HTTPURLResponse{
                    if (httpResponse.statusCode == 200){
                        
                        print("HTTP: 200 OK!\n")
                        
                        DispatchQueue.global().async {
                            
                            do{
                                
                                if (data != nil){
                                    
                                    if let jsonData = data{
                                        let decoder = JSONDecoder()
                                        
                                        var decodedRecipe = try decoder.decode(RecipeResponse.self, from:jsonData)
                                    
                                        
                                        dump(decodedRecipe)
                                        
                                        for recipeIndex in 0..<decodedRecipe.meals.count {
                                            var recipe = decodedRecipe.meals[recipeIndex]
                                            
                                            print(#function, "\(recipe)\n")
                                            
                                            DispatchQueue.main.async{
                                                self.recipeList = decodedRecipe
                                            }//main-sync
                                        }
                                    }
                                }else{
                                    print(#function, "No JSON data available.")
                                }//if..else
                                
                            }catch let error{
                                
                                print(#function, "Unable to decode data. Error: \(error)\n")
                                
                            }//do..catch
                            
                        }//dispatchQueue
                        
                        
                    }else{
                        print(#function, "Unable to receive response. httpResponse.statusCode : \(httpResponse.statusCode)\n")
                    }//if-200
                }else{
                    print(#function, "Unable to obtain HTTPResponse\n")
                }//if httpResponse not gotten
                
            }//if-else
        }//task
        task.resume()
    }//getRecipes

    
    //* get recipe by ID  *//
    
    func getRecipeByID(recipeID : String){
        
        print("GetRecipeByID() Fetching data from API called")
                
        //convert string to URL type
        guard let apiURL = URL(string: byRecipeIDURL(id: recipeID)) else{
            return
        }
        
        print(#function, "apiURL = \(apiURL)\n")
    
        
        //initiate asynchronosu background task
        let task = URLSession.shared.dataTask(with: apiURL){
            
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let err = error {
                
                print(#function, "Unable to connect to the web service :\(err)")
                
                return
            }else{
                
                print(#function, "Connected to web service\n")
                
                if let httpResponse = response as? HTTPURLResponse{
                    if (httpResponse.statusCode == 200){
                        
                        //if-ok
                        print("HTTP: 200 OK!\n")
                        
                        DispatchQueue.global().async {
                            
                            do{
                                
                                if (data != nil){
                                    
                                    if let jsonData = data{
                                        let decoder = JSONDecoder()
                                        
                                        var decodedRecipe = try decoder.decode(RecipeResponse.self, from:jsonData)
                                    
                                        
                                        dump(decodedRecipe)
                                        
                                        for recipeIndex in 0..<decodedRecipe.meals.count {
                                            var recipe = decodedRecipe.meals[recipeIndex]
                                            
                                            print(#function, "\(recipe)\n")
                                             
                                            DispatchQueue.main.async{
                                                self.recipe = decodedRecipe
                                            }//main-sync
                                        }
                                    }
                                }else{
                                    print(#function, "No JSON data available.")
                                }//if..else
                                
                            }catch let error{
                                
                                print(#function, "Unable to decode data. Error: \(error)\n")
                                
                            }//do..catch
                            
                        }//dispatchQueue
                        
                        
                    }else{
                        print(#function, "Unable to receive response. httpResponse.statusCode : \(httpResponse.statusCode)\n")
                    }//if-200
                }else{
                    print(#function, "Unable to obtain HTTPResponse\n")
                }//if httpResponse not gotten
                
            }//if-else
        }//task
        task.resume()
    }//getRecipes

    
}//recipeManager
