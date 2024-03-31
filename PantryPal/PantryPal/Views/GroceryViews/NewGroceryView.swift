//
//  NewGroceryView.swift
//  PantryPal
//
//  Created by Russell Tan on 2024-03-03.
//

import SwiftUI
import Photos

struct NewGroceryView: View {
    
    @State private var permissionGranted : Bool = false
    @State private var showSheet : Bool = false
    @State private var showPicker : Bool = false
    @State private var isUsingCamera : Bool = false
    @State private var profileImage : UIImage?
    
    var body: some View {
        VStack {
            VStack {
                Image(uiImage: (profileImage ?? UIImage(systemName: "placeholdertext.fill"))!)
                    .resizable()
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .frame(width: 300, height: 300)
                Button(action: {
                    if (self.permissionGranted){
                        //show the picers for selection
                        self.showSheet = true
                    }else{
                        self.requestPermissions()
                    }
                }){
                    Text("Add Grocery")
                        .padding(20)
                        .bold()
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
                //self.mlHelper.performClassification(for: profileImage!)
            }
            /*
             Text("\(self.mlHelper.classificationInfo)")
             .font(.title)
             .fontWeight(.bold)
             .foregroundColor(.red)
             .padding(.top)
             */
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
            //self.mlHelper.createRequest()
            //self.doReverseGeocoding()
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
}

