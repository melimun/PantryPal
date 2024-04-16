//  Group 7: Russell Tan - 991586877
//  CameraPicker.swift
//  PhotoLibraryDemo
//
//  Created by Jupiter on 2023-11-15.
//

import Foundation
import SwiftUI
import PhotosUI

struct CameraPicker : UIViewControllerRepresentable{
    
    @Binding var selectedImage : UIImage?
    @Binding var isPresented : Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = context.coordinator
        return cameraPicker
    }
    
    func updateUIViewController(_ uiViewController: CameraPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<CameraPicker>) {
        //nothing to update
    }
    
    func makeCoordinator() -> CameraPicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        
        var parent : CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //user done clicking the picture
            
            //get the clicked picture
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                //set the picture as image for the parent
                self.parent.selectedImage = image
                self.parent.isPresented.toggle()
                
                picker.dismiss(animated: true)
            }else{
                print(#function, "image not available from camera")
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //user cancelled clicking picture
            self.parent.isPresented.toggle()
        }
    }//Coordinator
    
}//CameraPicker
