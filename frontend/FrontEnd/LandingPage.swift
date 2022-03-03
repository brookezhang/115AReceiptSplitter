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
    @StateObject var totals = Totals()
    
    // States
    @State var uploadImage = false
    @State var isUpload = false
    @State var temp = [Item]()
    @State var isLoading = false
    @State private var buttonText = "Upload Photo"
    @State private var showAlert = false;
    
    // EnvironmentObjects
//    @EnvironmentObject var errorHandling: ErrorHandling
    
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
                                    self.isLoading.toggle()
                                    viewModel.sendBase64(image: image, completion: {list, err  in
                                        DispatchQueue.main.async {
                                            if (list == nil) { self.showAlert = true }
                                            if (err != nil) {
                                                self.showAlert = true
                                                print ("REPORT ERROR")
                                                return
                                            }
                                            self.isLoading.toggle()
                                            self.itemsTemp.itemsList = Array(list![0..<(list!.count - 3)])
                                            self.totals.totalsList = Array(list!.suffix(3))
                                            print ("uploaded and parsed")
                                            self.isUpload = true
                                        }
                                    })
                                }
                                .alert(
                                    isPresented: $showAlert,
                                    content: { Alert(title: Text("Hello world")) }
                                )
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
        .navigationViewStyle(.stack)
        .environmentObject(persons)
        .environmentObject(itemsTemp)
        .environmentObject(totals)
    }
}
