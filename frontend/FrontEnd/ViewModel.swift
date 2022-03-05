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
    @Published var isEmpty = true
    var itemsArr = [Item]()
    private(set) var sourceType: ImagePicker.SourceType = .camera
        
    func choosePhoto() {
        sourceType = .photoLibrary
        isPresentingImagePicker = true
        isEmpty = false
    }
    
    func takePhoto() {
        sourceType = .camera
        isPresentingImagePicker = true
        isEmpty = false
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
        case invalidImage
        case invalidJSONData
        case someError
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
            completion(nil, Errors.invalidJSONData)
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//                print(response)
//            }
            if let error = error {
                print("actual error", error)
                completion (nil, Errors.someError)
                return
            }
            if let response = response as? HTTPURLResponse {
                // print(response)
                print("statusCode: \(response.statusCode)")
                if response.statusCode == 503 || response.statusCode == 400 {
                    completion(nil, Errors.invalidImage)
                    return
                }
                if response.statusCode >= 300 {
                    completion(nil, Errors.someError)
                    return
                }
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Any] {
                        
                        self.itemsArr = []
                        for anItem in object as! [Dictionary<String, AnyObject>] {
                            guard let item = anItem["item_name"] as? String else {
                                completion(nil, Errors.invalidJSONData)
                                return
                            }
                            guard let price = anItem["price"] as? Double else {
                                completion(nil, Errors.invalidJSONData)
                                return
                            }
                            let full_item = Item(name: item, price: price, pplList: [String]())
                            self.itemsArr.append(full_item)
                        }
                        completion(self.itemsArr, nil)
                    } else { completion(nil, Errors.invalidImage) }
                } catch {
                    print("error in the catch", error)
                    completion(nil, Errors.invalidJSONData)
                }
            }
        }.resume()
    }
}
