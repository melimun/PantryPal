//  Group 7: Russell Tan - 991586877
//  LibraryPicker.swift
//  PhotoLibraryDemo
//
//  Created by Jupiter on 2023-11-15.
//

import Foundation

import SwiftUI
import PhotosUI

struct LibraryPicker : UIViewControllerRepresentable{
    
    @Binding var selectedImage : UIImage?
    @Binding var isPresented : Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = context.coordinator
        
        return imagePicker
        
    }
    
    func updateUIViewController(_ uiViewController: LibraryPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<LibraryPicker>) {
        //nothing to update
    }
    
    func makeCoordinator() -> LibraryPicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator : PHPickerViewControllerDelegate{
        
        var parent : LibraryPicker
        
        init(parent: LibraryPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //user has selected photo from library
            picker.dismiss(animated: true)
            
            if (results.count != 1){
                return
            }
            
            //get the image and set it to our response
            if let image = results.first{
                if image.itemProvider.canLoadObject(ofClass: UIImage.self){
                    
                    //convert the obtained object as Image
                    image.itemProvider.loadObject(ofClass: UIImage.self){image, error in
                        
                        guard error == nil else{
                            print(#function, "Cannot obtain UIImage type dur to error : \(String(describing: error))")
                            return
                        }
                        
                        if let myImage = image{
                            self.parent.selectedImage = myImage as? UIImage
                            
                            let identifiers = results.compactMap(\.assetIdentifier)
                            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
                            let imageMetaData = fetchResult[0]
                            
                            print(#function, "creationg date : \(imageMetaData.creationDate!)")
                            print(#function, imageMetaData.mediaType)
                            print(#function, imageMetaData.sourceType)
                            print(#function, imageMetaData.isFavorite)
                            print(#function, imageMetaData.duration)
                            
                        }
                    }
                }
            }
            
            self.parent.isPresented.toggle()
        }
        
        
    }
}
