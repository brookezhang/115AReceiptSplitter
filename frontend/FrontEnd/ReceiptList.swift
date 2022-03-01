import SwiftUI

class Peoples: ObservableObject {
    @Published var nameList : [Person] = [Person(name: "bobby"), Person(name: "joe")]
}

struct NamesView: View{
    //@ObservedObject var ppl = Peoples()
    @EnvironmentObject var ppl: People

    var columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 2)

    var body: some View{
        LazyVGrid(columns: columns, spacing: 10){
            ForEach(ppl.nameList){p in
                Text(p.name)
                    .onDrag { NSItemProvider(object: p.name as NSString) }
            }
        }
    }
}

struct ItemRow: View{
    @StateObject var item: Item
    var body: some View{
        VStack{
            HStack{
                Text(item.name)
                Spacer()
                Text("Price: \(item.price)")
            }.contentShape(Rectangle())
             .frame(height: 20)
             .padding(10)
            ZStack(alignment: .leading){
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(alignment: .center){
                        Text("Paid by: ")
                        ForEach(item.peopleList, id: \.self ){name in
                                Text(name)
                        }
                        Spacer(minLength: 0)
                    }.contentShape(Rectangle())
                    .frame(height: 20)
                }
            }.padding(10)
        }.background(Color.black.opacity(0.07))
         .cornerRadius(15)
         .onDrop(of: ["public.text"], delegate: item)
    }
}

struct ReceiptList: View {

    //@ObservedObject var itemsTemp = Items()
    @EnvironmentObject var itemsTemp: Items
    var body: some View {
        VStack{
            NamesView()
            ScrollView{
                LazyVStack(alignment: .leading, spacing: 10){
                    ForEach(itemsTemp.itemsList ){item in
                        ItemRow(item: item)
                    }
                }.padding(20)
            }
        }.navigationTitle("Drop names into items")
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptList()
    }
}

class Items: ObservableObject {
//    let id = UUID()
//    @Published var itemsList: [Item] = [
//        Item(name: "testing1", price: 200, pplList: [String]()),
//        Item(name: "testing2", price: 100, pplList: [String]()),
//    ]
    @Published var itemsList = [Item]()
}

class Item: ObservableObject,Identifiable, DropDelegate{
    let id = UUID()
    
    @Published var name: String
    @Published var price: Double
    @Published var peopleList: [String]
    
    init(name: String, price: Double, pplList: [String]) {
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

                              guard !self.peopleList.contains(inputStr) else {
                              return
                          }
                          
                          DispatchQueue.main.async {
                              self.peopleList.append(inputStr)
                              print(self.name, self.peopleList)
                          }
                      }
                  }
              } else {
                  return false
              }
            return true
    }

}
