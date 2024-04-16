//
//  SheetView.swift
//  PantryPal
//
//  Created by Christian on 2024-04-12.
//

import SwiftUI
import MapKit


struct SheetView: View {
    @State var locations: [Location]
    @State private var showAlert: Bool = false
    @State private var selectedLocation: Location?
    @EnvironmentObject var firebaseHelper : FireDBHelper
    
    var body: some View {
        VStack {
            Spacer()
            
            
            
            List {
                
                ForEach(self.locations, id: \.id) {
                    
                    location in
                    
                    Button{
                        
                        print(#function, "Clicking \(location.name)")
                        self.showAlert = true
                        self.selectedLocation = location
                        
                    }label:{
                        
                        HStack(alignment: .lastTextBaseline){
                            
                            
                            
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .fontWeight(.bold)
                                
                                Text(location.title)
                                    .foregroundColor(.black)
                            }//VStack
                        }//HStack
                        .padding()
                    }//Button
                    
                }//ForEach
                
            }//List
            .listStyle(.insetGrouped)
        }//VStack
       
    }
    
    
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
    
}

