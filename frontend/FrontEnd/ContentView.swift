import SwiftUI

struct LandingPageView: View {
    @StateObject var viewModel = ViewModel()
    @State var uploadImage = false
    @State var isUpload = false
    @StateObject var persons = People()

    var body: some View {
        
        NavigationView{
            VStack(spacing: 32) {
                Spacer()
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    NavigationLink(destination: Names(), isActive: $isUpload) {
                        VStack{
                            Button(action: {
                                viewModel.sendBase64(image: image)
                                self.isUpload = true
                            }) {
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
        .navigationViewStyle(.stack)
        .environmentObject(persons)

    }
}

struct ContentView: View {

    var body: some View {
        //LandingPageView()
        ReceiptList()
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
//            let params = ["base64": strBase64] as Dictionary<String, String>
//            print (params.keys)
//
//            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
//
//            var request = URLRequest(url: URL(string: "http://localhost:5000/get_items")!)
//            request.httpMethod = "GET"
//            // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//            request.httpBody = try! JSONSerialization.data(withJSONObject: [], options: .prettyPrinted)
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            // let session = URLSession.shared
//            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//                // print(response!)
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                    print(json)
//                } catch {
//                    print("error")
//                }
//            })
//
//            task.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

