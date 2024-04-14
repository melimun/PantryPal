//
//  ItemDetailsView.swift
//  PantryPal
//
//  Created by Christian on 2024-04-03.
//

import SwiftUI

struct ItemDetailsView: View {
    
    @State var itemID: String
    @EnvironmentObject var dbHelper : FireDBHelper
    @EnvironmentObject var itemManager : ItemManager
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


