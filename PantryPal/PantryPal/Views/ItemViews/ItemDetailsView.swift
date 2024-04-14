//
//  ItemDetailsView.swift
//  PantryPal
//
//  Created by Christian on 2024-04-03.
//

import SwiftUI

struct ItemDetailsView: View {
    
    @State var itemID: Int
    @EnvironmentObject var dbHelper : FireDBHelper
    @EnvironmentObject var itemManager : ItemManager
    
    
    var body: some View {
        VStack(){
            Text(itemManager.singleItem.name)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.blue)
                .font(.title)
            
            
            
        }.onAppear{
        self.itemManager.getItemById(id: String(itemID))
    }
}
}


