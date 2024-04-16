//
//  FireDBHelper.swift
//  PantryPal
//
//  Created by Michael Tan on 2024-03-30.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FireDBHelper : ObservableObject{
    
    //Dictionaries
    @Published var ingredientList = [Ingredient]()
    @Published var favouriteList = [RecipeFirebase]()

    
    private let db : Firestore
    private static var shared : FireDBHelper?
    
    // ??
    private let COLLECTION_NAME = "Ingredients"
    private let ATTRIBUTE_INGREDIMAGE = "ingredientImage"
    private let ATTRIBUTE_INGREDNAME = "ingredientName"
    private let ATTRIBUTE_PURCHDATE = "purchaseDate"
    private let ATTRIBUTE_EXPIRDATE = "expirationDate"
    private let ATTRIBUTE_PRICE = "price"
    
    //For Recipe Collection; Easier for names
    private let COLLECTION_RNAME = "Recipes"
    private let ATTRIBUTE_STRMEAL = "strMeal"
    private let ATTRIBUTE_IDMEAL = "idMeal"
    private let ATTRIBUTE_STRCATEGORY = "strCategory"
    private let ATTRIBUTE_STRMEALTHUMB = "strMealThumb"
    private let ATTRIBUTE_STRAREA = "strArea"
    private let ATTRIBUTE_STRINSTRUCTIONS = "strInstructions"
    private let ATTRIBUTE_STRTAGS = "strTags"
    private let ATTRIBUTE_STRYOUTUBE = "strYoutube"
    private let ATTRIBUTE_STRSOURCE = "strSource"
    private let ATTRIBUTE_STRIMAGESOURCE = "strImageSource"
    private let ATTRIBUTE_STRCREATIVECOMMONSCONFIRMED = "strCreativeCommonsConfirmed"
    private let ATTRIBUTE_DATEMODIFIED = "dateModified"
    private let ATTRIBUTE_INGREDIENTS = "ingredients"

    
    //Initialize firebase
    private init(database : Firestore){
        self.db = database
    }
    
    //create Instance of firestore
    static func getInstance() -> FireDBHelper{
        
        if (self.shared == nil){
            shared = FireDBHelper(database: Firestore.firestore())
        }
        
        return self.shared!
    }
    
    
    //* I N G R E D I E N T  F U N C T I O N S *//
    
    func insertIngredient(ingred : Ingredient){
        do {
            try self.db.collection(COLLECTION_NAME).addDocument(from: ingred)
        } catch let err as NSError {
            print(#function, "Unable to insert : \(err)")
        }
    }
    
    func deleteIngredient(docIDtoDelete : String) {
        self.db
            .collection(COLLECTION_NAME)
            .document(docIDtoDelete)
            .delete { error in
                if let err = error {
                    print(#function, "Unable to delete : \(err)")
                } else {
                    print(#function, "Document deleted successfully")
                }
            }
    }
    
    func retrieveAllIngredients() {
        do {
            self.db
                .collection(COLLECTION_NAME)
                .order(by: ATTRIBUTE_PRICE, descending: true)
                .addSnapshotListener( { (snapshot, error) in
                    guard let result = snapshot else {
                        print(#function, "Unable to retrieve snapshot : \(String(describing: error))")
                        return
                    }
                    
                    print(#function, "Result : \(result)")
                    
                    result.documentChanges.forEach{ (docChange) in
                        
                        do {
                            //obtain the document as Ingredient class object
                            let ingred = try docChange.document.data(as: Ingredient.self)
                            
                            print(#function, "ingred from db : id : \(String(describing: ingred.id)) ingredientName : \(ingred.ingredientName)")
                            
                            //check if the changed document is already in the list
                            let matchedIndex = self.ingredientList.firstIndex(where: { ($0.id?.elementsEqual(ingred.id!))!})
                            
                            if docChange.type == .added {
                                if (matchedIndex != nil) {
                                    //the document object is already in the list
                                    //do nothing to avoid duplicates
                                } else {
                                    self.ingredientList.append(ingred)
                                }
                                
                                print(#function, "New document added : \(ingred)")
                            }
                            
                            if docChange.type == .modified{
                                print(#function, "Document updated : \(ingred)")
                            /*
//                                if (matchedIndex != nil){
//                                    //the document object is already in the list
//                                    //replace existing document
//                                    self.ingredientList[matchedIndex!] = ingred
//                                }
                                */
                            }
                            
                            if docChange.type == .removed{
                                print(#function, "Document deleted : \(ingred)")
                                    /*
//                                if (matchedIndex != nil){
//                                    //the document object is still in the list
//                                    //delete existing document
//                                    self.ingredientList.remove(at: matchedIndex!)
//                                }*/
                            }
                            
                        }catch let err as NSError{
                            print(#function, "Unable to access document change : \(err)")
                        }
                        
                    }
                })
            
        }catch let err as NSError{
            print(#function, "Unable to retrieve \(err)" )
        }
        
    }
    
    @Published var retrievedImages = [UIImage]()
    
    func retrieveImages() {
        db.collection("Ingredients").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var paths = [String]()
                for doc in snapshot!.documents {
                    paths.append(doc["ingredientImage"] as! String)
                }
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)
                    fileRef.getData(maxSize: 5 * 1024 * 1024){ data, error in
                        if error == nil && data != nil {
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    self.retrievedImages.append(image)
                                }
                            }
                        }
                    }

                }
            }
        }
    }
    
    func updateIngredient( updatedIngredientIndex : Int ){
        
        //updateData more apprpropriate if some fields of document needs to be updated
        self.db
            .collection(COLLECTION_NAME)
            .document(self.ingredientList[updatedIngredientIndex].id!)
            .updateData([ATTRIBUTE_INGREDNAME : self.ingredientList[updatedIngredientIndex].ingredientName,
                         ATTRIBUTE_PURCHDATE : self.ingredientList[updatedIngredientIndex].purchaseDate,
                         ATTRIBUTE_EXPIRDATE : self.ingredientList[updatedIngredientIndex].expirationDate,
                         ATTRIBUTE_PRICE : self.ingredientList[updatedIngredientIndex].price,
                        ]){ error in
                
                if let err = error{
                    print(#function, "Unable to update document : \(err)")
                }else{
                    print(#function, "Document updated successfully")
                }
                
            }
    }
    
    
    //** R E C I P E  F U N C T I O N S **//
    
    func insertRecipe(recipe : RecipeFirebase){
        do{
            try self.db.collection(COLLECTION_RNAME).addDocument(from: recipe)
            
            print(#function, "Inserted into favourites")
            
        }catch let err as NSError{
            print(#function, "Unable to insert : \(err)")
        }
    }
    
    func deleteRecipe(docIDtoDelete : String){
        self.db
            .collection(COLLECTION_RNAME)
            .document(docIDtoDelete)
            .delete{error in
                if let err = error{
                    print(#function, "Unable to delete : \(err)")
                }else{
                    print(#function, "Document deleted successfully")
                }
            }
    }
    
    func retrieveAllRecipes() {
        self.db.collection(COLLECTION_RNAME)
            .order(by: ATTRIBUTE_DATEMODIFIED, descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
            guard let result = snapshot else {
                print(#function, "Unable to retrieve snapshot: \(error ?? "Unknown Error" as! Error)")
                return
            }
            
            result.documentChanges.forEach { docChange in
                do {
                    let favourite = try docChange.document.data(as: RecipeFirebase.self)
                    
                    if docChange.type == .added {
                        self?.favouriteList.append(favourite)
                    }
                    
                    if docChange.type == .modified {
                        // Handle modified document if needed
                    }
                    
                    if docChange.type == .removed {
                        if let index = self?.favouriteList.firstIndex(where: { $0.id == favourite.id }) {
                            self?.favouriteList.remove(at: index)
                        }
                    }
                    
                } catch let err as NSError {
                    print(#function, "Unable to access document change: \(err)")
                }
            }
        }
    }
    
    
}
