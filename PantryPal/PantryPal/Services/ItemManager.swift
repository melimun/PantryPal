//
//  ItemManager.swift
//  PantryPal
//
//  Created by Christian on 2024-04-12.
//

import Foundation

class ItemManager: ObservableObject {
    
    @Published var itemList : [TempModel] = []
    
    var apiString : String = "https://simple-grocery-store-api.glitch.me/products"
    
    @Published var itemIDs = [String]()
    
    @Published var singleItem : TempModel = TempModel()
    
    
    init(){
        self.fetchDataFromAPI()
    }
    
    func byItemIDURL(id: String){
        
    }
    
    func fetchDataFromAPI(){
        print("Fetching data from API called")
        
        //obtain URL from string
        guard let apiURL = URL(string: self.apiString) else{
            print(#function, "unable to obtain URL fro apiString.")
            return
        }
        
        print(#function, "api URL : \(apiURL)")
        
        //initialize background task to connect to network, web service
        let task = URLSession.shared.dataTask(with: apiURL){(data : Data?, response: URLResponse?, error : Error?) in
            
            if let err = error {
                print(#function, "Unable to connect to web service : \(err)")
                return
            }else{
                print(#function, "connected to web service")
                
                if let httpResponse = response as? HTTPURLResponse{
                    if (httpResponse.statusCode == 200){
                        //response is OK
                        
                        //asynchrounous task to decode the JSON data if received
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data{
                                        //obtain decoder instance
                                        let decoder = JSONDecoder()
                                        
                                        //decode data
                                        
//                                        //use when web service respond with single Launch object only
//                                        var decodedLaunchList = try decoder.decode(Launch.self, from: jsonData)
                                        
                                        //use when web service respond with array of Launch objects
                                        var decodedItemList = try decoder.decode([TempModel].self, from: jsonData)

                                        
                                        print(#function, "Number of objects received : \(decodedItemList.count)")
                                        
                                        print(#function, "decodedItemList : \(decodedItemList)")
                                        
                                        dump(decodedItemList)
                                        
                                        DispatchQueue.main.async {
                                            self.itemList = decodedItemList
                                        }
                                        
                                        
                                    }else{
                                        print(#function, "No JSON data available")
                                    }
                                }else{
                                    print(#function, "No data available to decode")
                                }
                            }catch let error{
                                print(#function, "Unable to decode data. Error : \(error)")
                            }//do..catch
                        }//async
                        
                    }else{
                        print(#function, "Unable to receive response. httpResponse.statusCode : \(httpResponse.statusCode)")
                    }
                }else{
                    print(#function, "Unable to obtain HTTPResponse")
                }
            }
        }
        
        //execute the background task
        task.resume()
    }//fetchDataFromAPI
    
    func getItemById(id : String) {
        print("Fetching data from API called")
        
        self.apiString = "https://simple-grocery-store-api.glitch.me/products/\(id)"
        
        //obtain URL from string
        guard let apiURL = URL(string: self.apiString) else{
            print(#function, "unable to obtain URL fro apiString.")
            return
        }
        
        print(#function, "api URL : \(apiURL)")
        
        //initialize background task to connect to network, web service
        let task = URLSession.shared.dataTask(with: apiURL){(data : Data?, response: URLResponse?, error : Error?) in
            
            if let err = error {
                print(#function, "Unable to connect to web service : \(err)")
                return
            }else{
                print(#function, "connected to web service")
                
                if let httpResponse = response as? HTTPURLResponse{
                    if (httpResponse.statusCode == 200){
                        //response is OK
                        
                        //asynchrounous task to decode the JSON data if received
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data{
                                        //obtain decoder instance
                                        let decoder = JSONDecoder()
                                        
                                        //decode data
                                        
//                                        //use when web service respond with single Launch object only
//                                        var decodedLaunchList = try decoder.decode(Launch.self, from: jsonData)
                                        
                                        //use when web service respond with array of Launch objects
                                        var decodedItem = try decoder.decode(TempModel.self, from: jsonData)

                                    
                                        
                                        print(#function, "decodedItem : \(decodedItem)")
                                        
                                        dump(decodedItem)
                                        
                                        DispatchQueue.main.async {
                                            self.singleItem = decodedItem
                                        }
                                        
                                        
                                    }else{
                                        print(#function, "No JSON data available")
                                    }
                                }else{
                                    print(#function, "No data available to decode")
                                }
                            }catch let error{
                                print(#function, "Unable to decode data. Error : \(error)")
                            }//do..catch
                        }//async
                        
                    }else{
                        print(#function, "Unable to receive response. httpResponse.statusCode : \(httpResponse.statusCode)")
                    }
                }else{
                    print(#function, "Unable to obtain HTTPResponse")
                }
            }
        }
        
        //execute the background task
        task.resume()
    }
    
}
    
