//
//  Pantry.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-02-10.
//

import SwiftUI

struct PantryView: View {
    @State private var selection = 0
    @State private var items = ["Item 1", "Item 2", "Item 3"]
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                List {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            Text(item)
                        }
                    }
                }
                .navigationBarTitle("Pantry List")
                .navigationBarItems(trailing:
                    NavigationLink(destination: NewItemView()) {
                        Image(systemName: "plus")
                    }
                )
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Pantry List")
            }
            
            NavigationView {

            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Recipes")
            }
        }
    }
}

struct DetailView: View {
    var item: String
    @State private var name: String = ""
    @State private var datePurchased: String = ""
    @State private var dateSpoil: String = ""
    var body: some View {
        Form {
              Section(header: Text("Grocery Information")) {
                  TextField("Name", text: $name)
                  TextField("Date Purchased", text: $datePurchased)
                  TextField("Expected Spoil Date", text: $dateSpoil)
              }
          }
        .navigationBarTitle(item)
    }
}

struct NewItemView: View {
    var body: some View {
        Text("New Item View")
            .navigationBarTitle("New Item")
    }
}
