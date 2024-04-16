//
//  FireStorageHelper.swift
//  PantryPal
//
//  Created by Russell on 2024-04-14.
//

import Foundation
import FirebaseStorage

class FireStorageHelper : ObservableObject{
    
    private let storage : Storage
    private static var shared : FireStorageHelper?
    
    //Initialize firebase
    private init(storage : Storage){
        self.storage = storage
    }
    
    //create Instance of firestore
    static func getInstance() -> FireStorageHelper{
        
        if (self.shared == nil){
            shared = FireStorageHelper(storage: Storage.storage())
        }
        
        return self.shared!
    }
    
    func persistImageToStrorage() {
        let filename = UUID().uuidString
        
    }
    
}
