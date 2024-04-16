//
//  MLHelper.swift
//  PantryPal
//
//  Created by Russell on 2024-04-13.
//

import Foundation
import CoreML
import Vision
import UIKit

class MLHelper: ObservableObject{
    @Published var classificationInfo : String = ""
    private var classificationRequest : VNCoreMLRequest?
    
    func createRequest(){
        do{
            //create a reference to ML model
            let model102 = try VNCoreMLModel(for: ingred(configuration: MLModelConfiguration()).model)
            
            //create an instance of request
            let request = VNCoreMLRequest(model: model102, completionHandler: { request, error in
                //request.usesCPUOnly = true
                if (error == nil){
                    self.executeRequest(for: request, error: error)
                }else{
                    print(#function, "Couldn't create request : \(String(describing: error))")
                }
            })
            #if targetEnvironment(simulator)
            request.usesCPUOnly = true
            #endif
            request.imageCropAndScaleOption = .centerCrop
            self.classificationRequest = request
            
        }catch let err{
            print(#function, "Unable to create request due to error : \(err)")
        }
    }
    
    func executeRequest(for request: VNRequest, error : Error?){
        
        DispatchQueue.main.async {
            
            guard let results = request.results else{
                self.classificationInfo = "Unable to classify image : \(String(describing: error))"
                return
            }
            
            let classificationList = results as! [VNClassificationObservation]
            
            if classificationList.isEmpty{
                print(#function, "Image isn't matching to any category")
                self.classificationInfo = "No match"
            }else{
                //select top 4 categories based on confidence
                let topClassifications = classificationList.prefix(upTo: 1 )
                
                let descriptions = topClassifications.map{ category in
                    return category.identifier
                }
                self.classificationInfo = "\(descriptions.joined(separator: "\n"))"
            }
        }
    }
    
    func performClassification(for selectedImage : UIImage){
        
        guard let ciImageInput = CIImage(image: selectedImage) else{
            self.classificationInfo = "Error : Unable to obtain CIImage"
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImageInput)
        
        do{
            if (self.classificationRequest != nil){
                try handler.perform([self.classificationRequest!])
            }else{
                print(#function, "Request object unavailable to execute")
            }
        }catch{
            print(#function, "Unable to perfor classification \(error)")
        }
    }
}
