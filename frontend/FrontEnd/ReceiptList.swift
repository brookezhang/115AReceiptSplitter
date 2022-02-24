import SwiftUI

struct NamesView: View{
    @State private var names: [String] = ["Bob", "Joe", "Billy", "Chanel"]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)

    var body: some View{
        LazyVGrid(columns: columns, spacing: 10){
            ForEach(names, id: \.self){name in
                Text(name)
                    .onDrag { NSItemProvider(object: name as NSString) }
            }
        }
    }
}

struct SingleItem: View{
    @StateObject var singleItem: Item
    var body: some View{
        HStack{
            Text(singleItem.name)
            Spacer()
            Text("Price: \(singleItem.price)")
        }.contentShape(Rectangle())
         .frame(height: 20)
         .padding(10)
        
        ZStack(alignment: .leading){
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .center){
                    Text("Paid by: ")
                    ForEach(singleItem.peopleList, id: \.self ){name in
                            Text(name)
                    }
                    Spacer(minLength: 0)
                }.contentShape(Rectangle())
                .frame(height: 30)
            }.onDrop(of: ["public.text"], delegate: singleItem)
        }.padding(10)
    }
}

struct ReceiptList: View {

    @ObservedObject var delgate = Items()
    @ObservedObject var singleItem = Item(name: "One item", price: 200, pplList: [String]())
    @ObservedObject var singleItem2 = Item(name: "Two item", price: 200, pplList: [String]())

    var body: some View {
        VStack{
            NamesView()
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 10){
                    SingleItem(singleItem: singleItem)
                    SingleItem(singleItem: singleItem2)
                }.padding(20)
            }
        }
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptList()
    }
}

class Items: ObservableObject, DropDelegate {
    @Published var itemsList: [Item] = [
        Item(name: "testing1", price: 200, pplList: ["hello", "hi"]),
        Item(name: "testing2", price: 100, pplList: ["hi"]),
    ]
    @Published var test : [String] = ["Test"]
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: ["public.text"]).first {
                  // Load the item
                  item.loadItem(forTypeIdentifier: "public.text", options: nil) { (text, err) in
                      // Cast NSSecureCoding to Ddata
                      if let data = text as? Data {
                          // Extract string from data
                          let inputStr = String(decoding: data, as: UTF8.self)
                          DispatchQueue.main.async {
                              print(inputStr)
                              self.test.append(inputStr)
                              print(self.test)
                          }
                      }
                  }
              } else {
                  return false
              }
            return true
    }
}

class Item: ObservableObject,Identifiable, DropDelegate{
    let id = UUID()
    
    @Published var name: String
    @Published var price: Int
    @Published var peopleList: [String]
    
    init(name: String, price: Int, pplList: [String]) {
        self.name = name
        self.price = price
        self.peopleList = pplList
    }
    func performDrop(info: DropInfo) -> Bool {
        if let item = info.itemProviders(for: ["public.text"]).first {
                  // Load the item
                  item.loadItem(forTypeIdentifier: "public.text", options: nil) { (text, err) in
                      // Cast NSSecureCoding to Ddata
                      if let data = text as? Data {
                          // Extract string from data
                          let inputStr = String(decoding: data, as: UTF8.self)
                          DispatchQueue.main.async {
                              print(inputStr)
                              self.peopleList.append(inputStr)
                              print(self.peopleList)
                          }
                      }
                  }
              } else {
                  return false
              }
            return true
    }
    // setting Action as Move...
    func dropUpdated(info: DropInfo) -> DropProposal? {
      return DropProposal(operation: .move)
    }

}
