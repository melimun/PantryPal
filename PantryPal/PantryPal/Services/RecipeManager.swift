// Melissa Munoz / Eli - 991642239

import Foundation
import UIKit

class RecipeManager : ObservableObject{
    
    @Published var recipeList = [Recipe()]
    
    
    //polymorphism
    func getURL() -> String{
        
        let baseURL = "https://api.edamam.com/api/recipes/v2?type=public&app_id=193be525&app_key=89bf827911b8b9c669787660a80dad82"
        
        return baseURL
    }
    
    func getURL(specification:String) -> String{
        
        //ToDo: Review API parameters
        let baseURL = "https://api.edamam.com/api/recipes/v2?type=public&app_id=193be525&app_key=89bf827911b8b9c669787660a80dad82" + specification
        
        return baseURL
    }
    

    
    func getBooks(){
        
        print("GetBooks() Fetching data from API called")
                
        //convert string to URL type
        guard let apiURL = URL(string: getURL()) else{
            return
        }
    
        
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
                                        
                                        var decodedRecipe = try decoder.decode([Recipe].self, from:jsonData)
                                        
                                        //                                        dump(decodedBook)
                                        
                                        
                                        for recipeIndex in 0..<decodedRecipe.count {
                                            var recipe = decodedRecipe[recipeIndex]
                                            
                                            //                                            if let thumbnailURL = recipe.volumeInfo.imageLinks?.thumbnail {
                                            
                                            //                                                self.fetchImageFromAPI(from: thumbnailURL) {
                                            //
                                            //                                                    imageData in
                                            //
                                            //                                                    DispatchQueue.main.async {
                                            //                                                        if let imageData = imageData, let image = UIImage(data: imageData) {
                                            //
                                            //
                                            //                                                            book.volumeInfo.image = image
                                            //                                                            self.objectWillChange.send() // Notify SwiftUI of changes
                                            //
                                            //
                                            //                                                            self.bookList.items[recipeIndex] = book
                                            //
                                            //
                                            //                                                        } else {
                                            //                                                            print(#function, "Failed to get image data for recipe with index \(recipeIndex).")
                                            //                                                        }
                                            //                                                    }//Dispatch
                                            //                                                }//fetchDatafromApi
                                            //                                            } else {
                                            //                                                print(#function, "No JSON data of small thumbnail available for book with index \(bookIndex).")
                                            //                                            }//if-else
                                            //                                        }//GrabImageData
                                            //
                                            DispatchQueue.main.async{
                                                self.recipeList = decodedRecipe
                                            }//main-sync
                                            
                                            //                                    }
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
    }//getBooks
    
    
    //it will escape once it is completed
    func fetchImageFromAPI(from url: URL, withCompletion completion : @escaping(Data?) -> Void){
                
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if (error != nil){
                
                print(#function, "unable to connect to image hosting web server due to error: \(error)")
            }else{
                
                if let httpResponse = response as? HTTPURLResponse{
                    print(#function, "httpResponse: \(httpResponse)")
                    
                    if (httpResponse.statusCode == 200){
                        
                        if (data != nil){
                        
                            completion(data)
                            
                        }else{
                            print(#function, "No data from server response found.")
                        }//if-else data is not nil
                        
                    }else{
                        
                        print(#function, "HTTP response is not OK: \(httpResponse.statusCode).")
                        
                    }//if 200
                    
                }//if let httpResponse
            }//if-else
        })//lambda
        
        task.resume()
        
    }//fetchImageFromApi
    
}//bookManager
