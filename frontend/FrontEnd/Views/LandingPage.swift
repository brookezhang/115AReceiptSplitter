//
//  LandingPage.swift
//  FrontEnd
//
//  Created by sidrah munir on 3/2/22.
//

import SwiftUI

struct LandingPageView: View {
    // StateObjects
    @StateObject var viewModel = ViewModel()
    @StateObject var persons = People()
    @StateObject var itemsTemp = Items()
    
    // States
    @State var uploadImage = false
    @State var isUpload = false
    @State var temp = [Item]()
    @State var isLoading = false
    @State private var buttonText = "Upload Photo"
    @State private var showAlert = false;
    @State private var alertMsg = "Receipt could not be processed"
    @State private var disabled = true

    
    var body: some View {
        
        NavigationView{
            LoadingView(isShowing: $isLoading) {
                VStack(spacing: 32) {
                    Spacer()
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        NavigationLink(destination: Names(), isActive: $isUpload) {
                            VStack{
                                Button(buttonText) {
                                    self.isLoading = true
                                    viewModel.sendBase64(image: image, completion: {list, err  in
                                        DispatchQueue.main.async {
                                            if (err != nil) {
                                                print ("err", "\(err!)")
                                                if ("\(err!)" == "invalidJSONData") {
                                                    self.alertMsg = "Server parsing error"
                                                }
                                                else if ("\(err!)" == "invalidImage"){
                                                    self.alertMsg = "Image not of receipt"
                                                }
                                                self.isLoading = false
                                                self.showAlert = true
                                                self.viewModel.isEmpty = true
                                                print ("REPORT ERROR")
                                                return
                                            }
                                            self.isLoading = false
                                            self.itemsTemp.itemsList = Array(list![0..<(list!.count - 1)])
                                            self.itemsTemp.subtotal = Array(list!.suffix(1))[0].price
                                            print ("uploaded and parsed")
                                            self.isUpload = true
                                        }
                                    })
                                }
                                .font(.headline)
                                .alert(
                                    isPresented: $showAlert,
                                    content: { Alert(title: Text(alertMsg)) }
                                )
                            }
                        }.disabled(viewModel.isEmpty)
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
                        }).disabled(disabled)
                    }.padding()
                    
                    
                }
                .navigationTitle("TabDrop")
                .fullScreenCover(isPresented: $viewModel.isPresentingImagePicker, content: {
                    ImagePicker(sourceType: viewModel.sourceType, completionHandler: viewModel.didSelectImage)
                })
            }
        }
        .navigationViewStyle(.stack)
        .environmentObject(persons)
        .environmentObject(itemsTemp)
    }
}
