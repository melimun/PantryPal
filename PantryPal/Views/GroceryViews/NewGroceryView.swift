//
//  NewGroceryView.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-03-03.
//

import SwiftUI
import Photos
import FirebaseStorage

struct NewGroceryView: View {
    
    @EnvironmentObject var dbHelper : FireDBHelper
    @ObservedObject var mlHelper = MLHelper()
    
    @EnvironmentObject var stHelper : FireStorageHelper
    
    @State private var permissionGranted : Bool = false
    @State private var showSheet : Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    @State private var profileImage : UIImage?
    
    @State private var item: String = ""
    @State private var name: String = ""
    @State private var datePurchased: String = ""
    @State private var dateSpoil: String = ""
    @State private var price: String = ""
    
    @State private var path: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    if (self.permissionGranted){
                        //show the picers for selection
                        self.showSheet = true
                    }else{
                        self.requestPermissions()
                    }
                }){
                    Image(uiImage: (profileImage ?? UIImage(systemName: "plus.app"))!)
                        .resizable()
                        //.aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                }
                .actionSheet(isPresented: $showSheet){
                    ActionSheet(title: Text("Select Photo"),
                                message: Text("Choose photo to upload"),
                                buttons: [
                                    .default(Text("Choose from Photo Library")){
                                        //TODO when user wants to pick picture from the library
                                        self.showPicker = true
                                    },
                                    .default(Text("Take a new photo from Camera")){
                                        //TODO when user wants to open camera and click new picture
                                        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                                            print(#function, " Camera is unavailable ")
                                            return
                                        }
                                        print(#function, " Camera is available ")
                                        self.isUsingCamera = true
                                        self.showPicker = true
                                    },
                                    .cancel()
                                ]
                    )//ActionSheet
                }//.actionSheet()
            }
            .onChange(of: self.profileImage){_ in
                // perform classification
                //obtain image using the flower name and send it for classification
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none

                let today = Date()
                let calendar = Calendar.current
                var s = Date()
                
                if let newDate = calendar.date(byAdding: .day, value: 14, to: today) {
                    s = newDate
                }
                
                let formattedDate = dateFormatter.string(from: today)
                let formattedDates = dateFormatter.string(from: s)
                
                self.mlHelper.performClassification(for: profileImage!)
                self.name = "\(self.mlHelper.classificationInfo)"
                self.datePurchased = formattedDate
                self.dateSpoil = formattedDates
            }
            
            Spacer()
            
            TextField("Name", text: $mlHelper.classificationInfo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Date Purchased", text: $datePurchased)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Expected Spoil Date", text: $dateSpoil)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            TextField("Price", text: $price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            
            Spacer()
            
            HStack {
                Button(action: {
                    // Action for cancel button
                    
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(20)
                }
                .padding()
                Spacer()
                Button(action: {
                    uploadPhoto()
                    addIngredient()
                    //self.dbHelper.retrieveImages()
                }) {
                    Text("Accept")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .padding()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }//VStack
        .navigationTitle("Add Item")
        .padding()
        .fullScreenCover(isPresented: $showPicker){
            if (isUsingCamera){
                //show camera selection
                CameraPicker(selectedImage: self.$profileImage, isPresented: self.$showPicker)
            } else {
                //open PhotoLibrary
                LibraryPicker(selectedImage: self.$profileImage, isPresented: self.$showPicker)
            }
        }//fullScreenCover
        .onAppear {
            self.checkPermissions()
            self.mlHelper.createRequest()
        }
    }//body
    
    private func checkPermissions(){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            self.permissionGranted = true
        case .denied, .notDetermined:
            self.requestPermissions()
        @unknown default:
            break
        }
    }
    
    private func requestPermissions(){
        PHPhotoLibrary.requestAuthorization{status in
            switch status{
            case .authorized, .limited, .restricted:
                self.permissionGranted = true
            case .denied, .notDetermined:
                self.permissionGranted = false
                return
            @unknown default:
                return
            }
        }
    }
    
    private func addIngredient() {
        print(#function, "Add Ingredient function called")
        
        
        print(#function, "Attempting to add ingredient to firebase...")
        
        let newIngredient = Ingredient(ingredientImage : self.path,
            ingredientName: self.mlHelper.classificationInfo, purchaseDate: self.datePurchased, expirationDate: self.dateSpoil, price: (self.price as NSString).floatValue
        )
        
        self.dbHelper.insertIngredient(ingred: newIngredient)
        
        print(#function, "Ingredient added to Firebase")
    }
    
    private func uploadPhoto() {
        
        guard profileImage != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = profileImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        self.path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            
            if error == nil && metadata != nil {
                
            }
        }
    }
        
}

