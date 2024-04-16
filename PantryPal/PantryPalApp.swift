//
//  PantryPalApp.swift
//  PantryPal
//
//  Created by Eli Munoz on 2024-02-06.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

@main
struct PantryPalApp: App {
    
    let recipeManager = RecipeManager()
    let fireDBHelper : FireDBHelper
    let fireStorageHelper : FireStorageHelper
    
    init() {
        FirebaseApp.configure()
        fireDBHelper = FireDBHelper.getInstance()
        fireStorageHelper = FireStorageHelper.getInstance()
    }
    
    var body: some Scene {
        WindowGroup {
            PantryView()
                .environmentObject(self.recipeManager)
                .environmentObject(fireDBHelper)
                .environmentObject(fireStorageHelper)
        }
    }
}
