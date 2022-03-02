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
    // @ObservedObject var itemsTemp = Items()
    var itemsArr = [Item]()
    private(set) var sourceType: ImagePicker.SourceType = .camera
    
    // @Published var totals = [Item]()
    
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
    
    func sendBase64 (image: UIImage, completion: @escaping ([Item]?) -> Void) {
        let strBase64 = convertImageToBase64String(img: image)
        let Url = String(format: "https://tabdropbackend.herokuapp.com/items")
        guard let serviceUrl = URL(string: Url) else {
            completion(nil)
            return
        }
        let parameterDictionary = ["base64" : strBase64]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            completion(nil)
            return
        }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
//            if let response = response {
//                //print(response)
//            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Any] {
                        self.itemsArr = []
                        for anItem in object as! [Dictionary<String, AnyObject>] {
                            let item = anItem["item_name"] as! String
                            let price = anItem["price"] as! Double
                            let full_item = Item(name: item, price: price, pplList: [String]())
//                            if (item == "Subtotal" || item == "Tax" || item == "Total") {
//                                // print (item, price)
//                                self.totals.append(full_item)
//                            } else {
//                                self.itemsArr.append(full_item)
//                            }
                            self.itemsArr.append(full_item)
                        }
                        // print ("dispatch", self.itemsArr)
                        completion(self.itemsArr)
                    } else { completion(nil) }
                } catch {
                    print("error", error)
                }
            }
        }.resume()
    }
}
