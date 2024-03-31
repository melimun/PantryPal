//
//  PantryPalApp.swift
//  PantryPal
//
//  Created by Eli Munoz on 2024-02-06.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct PantryPalApp: App {
    
    let recipeManager = RecipeManager()

    
    var body: some Scene {
        WindowGroup {
            PantryView()
                .environmentObject(self.recipeManager)
        }
    }
}
