//
//  ViewModel.swift
//  FrontEnd
//
//  Created by sidrah munir on 3/2/22.
//

import Foundation
import SwiftUI

// https://augmentedcode.io/2020/11/22/using-an-image-picker-in-swiftui/
class ViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isPresentingImagePicker = false
    var itemsArr = [Item]()
    private(set) var sourceType: ImagePicker.SourceType = .camera
        
    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
    }
    
    func takePhoto() {
        sourceType = .camera
        isPresentingImagePicker = true
    }
    
    func didSelectImage (image: UIImage?) {
        selectedImage = image
        isPresentingImagePicker = false
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        let imageData:NSData = img.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    enum Errors: Error {
        case urlInvalid
        case dataIsNil
    }

    func sendBase64 (image: UIImage, completion: @escaping ([Item]?, Error?) -> Void) {
        let strBase64 = convertImageToBase64String(img: image)
        let Url = String(format: "https://tabdropbackend.herokuapp.com/items")
        guard let serviceUrl = URL(string: Url) else {
            completion(nil, Errors.urlInvalid)
            return
        }
        let parameterDictionary = ["base64" : strBase64]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            completion(nil, nil)
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
//            if let response = response {
//                //print(response)
//            }
            // print ("is there an error? ", error!)
            if let error = error {
                print("actual error", error)
                completion (nil, error)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Any] {
                        self.itemsArr = []
                        for anItem in object as! [Dictionary<String, AnyObject>] {
                            let item = anItem["item_name"] as! String
                            let price = anItem["price"] as! Double
                            let full_item = Item(name: item, price: price, pplList: [String]())
                            self.itemsArr.append(full_item)
                        }
                        completion(self.itemsArr, nil)
                    } else { completion(nil, nil) }
                } catch {
                    print("error", error)
                    completion(nil, Errors.dataIsNil)
                }
            }
        }.resume()
    }
}
