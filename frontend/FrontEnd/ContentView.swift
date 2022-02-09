//
//  ContentView.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 1/23/22.
//

import SwiftUI

struct LandingPageView: View {
    @StateObject var viewModel = ViewModel()
    @State var uploadImage = false
    
    var body: some View {
        
        NavigationView{
            VStack(spacing: 32) {
                Spacer()
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    NavigationLink(destination: EmptyView()) {
                        VStack{
                            // Text("Upload Photo").font(.headline)
                            Button(action: {viewModel.sendBase64(image: image)}) {
                                Text("Upload Photo")
                                    .font(.headline)
                            }
                        }
                    }
                }
                else {
                    Text("Upload an image of a receipt")
                }
                Spacer()
                VStack(spacing: 32) {
                    
                    Button(action: viewModel.choosePhoto, label: {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        Text("Choose Photo")
                            .font(.headline)
                    })
                    Button(action: viewModel.takePhoto, label: {
                        Image(systemName: "camera")
                            .font(.system(size: 20))
                        Text("Take a Photo")
                            .font(.headline)
                    })
                }.padding()
                
                
            }
            .navigationTitle("TabDrop")
            .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker, content: {
                ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
            })
        }
    }
}

struct ContentView: View {
    var body: some View {
        LandingPageView()
    }
}

final class ViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var isPresentingImagePicker = false
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
    
    func sendBase64 (image: UIImage) {
        let strBase64 = convertImageToBase64String(img: image)
        
        // comment this out once we get API working
        if (strBase64 != "") {
            print ("strBase64")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
