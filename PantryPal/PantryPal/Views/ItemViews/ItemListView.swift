//
//  ItemListView.swift
//  PantryPal
//
//  Created by Christian on 2024-04-03.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var itemManager : ItemManager
    @EnvironmentObject var dbHelper : FireDBHelper
    @State private var isPageLoaded = false // Track if the page is loaded
    
    var body: some View {
        NavigationView{
            VStack{
                if(self.itemManager.itemList.isEmpty){
                    Text("No data received from API")
                }else{
                    List(self.itemManager.itemList){item in
                        NavigationLink(destination: ItemDetailsView(itemID: item.itemId)
                            .environmentObject(self.dbHelper).environmentObject(self.itemManager)
                        ) {
                            VStack(){
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.blue)
                                    .font(.title)
                                
                                Text(item.category)
                                    .multilineTextAlignment(.center)
                                
                                Text(String(item.inStock))
                                    .multilineTextAlignment(.center)
                                
                                Text(String(item.itemId))
                                    .multilineTextAlignment(.center)
                                
                                Text(String(item.price))
                                    .multilineTextAlignment(.center)
                                
                                Text(item.manufacturer)
                                    .multilineTextAlignment(.center)
                                
                            }
                        }
                        
                        
                    }
                }
            }
        }.onAppear {
            fetchItems()
        }
        
        
    }
    func fetchItems() {
        self.itemManager.fetchDataFromAPI()
    }
}



#Preview {
    ItemListView()
}
