//
//  FireDBHelper.swift
//  PantryPal
//
//  Created by Michael Tan on 2024-03-30.
//

import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject{
    
    //Dictionaries
    @Published var studentList = [Ingredient]()
    @Published var favouriteList = [RecipeFirebase]()

    
    private let db : Firestore
    private static var shared : FireDBHelper?
    
    // ??
    private let COLLECTION_NAME = "Ingredients"
    private let ATTRIBUTE_FNAME = "firstname"
    private let ATTRIBUTE_LNAME = "lastname"
    private let ATTRIBUTE_COOP = "coop"
    private let ATTRIBUTE_GPA = "gpa"
    private let ATTRIBUTE_CCR = "ccr"
    private let ATTRIBUTE_PROGRAM = "program"
    
    //For Recipe Collection; Easier for names
    private let COLLECTION_RNAME = "Recipes"
    private let ATTRIBUTE_STRMEAL = "strMeal"
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
    
    func insertIngredient(stud : Ingredient){
        do{
            
            try self.db.collection(COLLECTION_NAME).addDocument(from: stud)
            
        }catch let err as NSError{
            print(#function, "Unable to insert : \(err)")
        }
    }
    
    func deleteIngredient(docIDtoDelete : String){
        self.db
            .collection(COLLECTION_NAME)
            .document(docIDtoDelete)
            .delete{error in
                if let err = error{
                    print(#function, "Unable to delete : \(err)")
                }else{
                    print(#function, "Document deleted successfully")
                }
            }
    }
    
    func retrieveAllIngredients(){
        
        do{
            
            self.db
                .collection(COLLECTION_NAME)
                .order(by: ATTRIBUTE_GPA, descending: true)
                .addSnapshotListener( { (snapshot, error) in
                    
                    guard let result = snapshot else{
                        print(#function, "Unable to retrieve snapshot : \(error)")
                        return
                    }
                    
                    print(#function, "Result : \(result)")
                    
                    result.documentChanges.forEach{ (docChange) in
                        
                        do{
                            //obtain the document as Ingredient class object
                            let stud = try docChange.document.data(as: Ingredient.self)
                            
                            print(#function, "stud from db : id : \(stud.id) firstname : \(stud.firstname)")
                            
                            //check if the changed document is already in the list
                            let matchedIndex = self.studentList.firstIndex(where: { ($0.id?.elementsEqual(stud.id!))!})
                            
                            if docChange.type == .added{
                                
                                if (matchedIndex != nil){
                                    //the document object is already in the list
                                    //do nothing to avoid duplicates
                                }else{
                                    self.studentList.append(stud)
                                }
                                
                                print(#function, "New document added : \(stud)")
                            }
                            
                            if docChange.type == .modified{
                                print(#function, "Document updated : \(stud)")
                                
//                                if (matchedIndex != nil){
//                                    //the document object is already in the list
//                                    //replace existing document
//                                    self.studentList[matchedIndex!] = stud
//                                }
                            }
                            
                            if docChange.type == .removed{
                                print(#function, "Document deleted : \(stud)")
                                
//                                if (matchedIndex != nil){
//                                    //the document object is still in the list
//                                    //delete existing document
//                                    self.studentList.remove(at: matchedIndex!)
//                                }
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
    
    func retrieveIngredientByFirstname(fname : String){
        do{
            
            self.db
                .collection(COLLECTION_NAME)
                .whereField("firstname", isGreaterThanOrEqualTo: fname)
//                .whereField("gpa", isGreaterThan: 3.4 )
//                .whereField("firstname", in: [fname, "Amy", "James])
//                .order(by: "gpa", descending: true)
                .addSnapshotListener( { (snapshot, error) in
                    
                    guard let result = snapshot else {
                        print(#function, "Unable to search database for the firstname due to error  : \(error)")
                        return
                    }
                    
                    print(#function, "Result of search by first name : \(result)")
                    
                    result.documentChanges.forEach{ (docChange) in
                        //try to convert the firestore document to Ingredient object and update the studentList
                        do{
                            let stud = try docChange.document.data(as: Ingredient.self)
                            
                            if docChange.type == .added{
                                self.studentList.append(stud)
                            }
                        }catch let err as NSError{
                            print(#function, "Unable to obtain Ingredient object \(err)" )
                        }
                    }
                })
            
        }catch let err as NSError{
            print(#function, "Unable to retrieve \(err)" )
        }
    }
    
    func updateIngredient( updatedIngredientIndex : Int ){
        
//        //setData more apprpropriate if entire document needs to be updated
//        do{
//            try self.db
//                .collection(COLLECTION_NAME)
//                .document(self.studentList[updatedIngredientIndex].id!)
//                .setData(from: self.studentList[updatedIngredientIndex])
//        }catch let err as NSError{
//            print(#function, "Unable to update \(err)" )
//        }
        
        //updateData more apprpropriate if some fields of document needs to be updated
        self.db
            .collection(COLLECTION_NAME)
            .document(self.studentList[updatedIngredientIndex].id!)
            .updateData([ATTRIBUTE_FNAME : self.studentList[updatedIngredientIndex].firstname,
                         ATTRIBUTE_LNAME : self.studentList[updatedIngredientIndex].lastname,
                         ATTRIBUTE_CCR : self.studentList[updatedIngredientIndex].ccr,
                         ATTRIBUTE_GPA : self.studentList[updatedIngredientIndex].gpa,
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
