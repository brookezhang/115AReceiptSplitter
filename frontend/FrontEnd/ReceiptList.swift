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
            ForEach(ppl.nameList, id:\.self){name in
                Text(name)
                    .onDrag { NSItemProvider(object: name as NSString) }
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
                Text("Price: $\(String(format: "%.2f", item.price))")
            }.contentShape(Rectangle())
             .frame(height: 20)
             .padding(10)
            
            HStack{
                if (!item.peopleList.isEmpty) {
                    Button(action: {
                        item.peopleList = [String]()
                    }) {
                        Text("  Reset")
                    }
                    Spacer()
                    Text("Price per person: $\(String(format: "%.2f", (item.price / Double(item.peopleList.count))))")
                }
//                else {
//                    Text("Price per person: $\(String(format: "%.2f", item.price))")
//                }
            }.padding(.trailing, 10)
                .frame(height: 10)
            
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

struct NewItem: View {
    @EnvironmentObject var itemsTemp: Items
    @State private var name: String = ""
    @State private var priceStr: String = ""
    @State private var isAdded = false
    @State private var showingAlert = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Enter New Item")){
                    HStack{
                        TextField("New Item", text: $name)
                    }
                }
                Section(header: Text("Enter Item Price")){
                    HStack{
                        TextField("Item Price", text: $priceStr)
                    }
                }
                Button("Add item") {
                    showingAlert = true
                    itemsTemp.addItem(name: name, price: Double(priceStr)!)
                    name = ""
                    priceStr = ""
                }
                .alert("Item is added!", isPresented: $showingAlert) {
                    Button("Ok", role: .cancel) { }
                }
                
            }
        }
        .navigationTitle("Add New Item")
    }
}

struct ReceiptList: View {

    //@ObservedObject var itemsTemp = Items()
    @EnvironmentObject var itemsTemp: Items
    @State private var isCalc = false
    @State private var isAdd = false
    
    var body: some View {
        VStack {
            NamesView()
            NavigationLink(destination: FinalSplit(itemls: itemsTemp), isActive: $isCalc) {
                Button("Calculate Final Split") {
                    itemsTemp.makeList()
                    isCalc = true
                }.font(.headline)
                    
            }
            List {
                Section {
                    ForEach (itemsTemp.itemsList) {item in
                        ItemRow(item: item)
                    }
                    .onDelete(perform: {
                        indexSet in itemsTemp.itemsList.remove(atOffsets:indexSet)
                    })
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Drop names into items")
        .navigationBarItems(trailing: NavigationLink(destination: NewItem(), isActive: $isAdd) {addItemButton})
    }
    
    var addItemButton: some View {
        Button(action: {
//            self.itemsTemp.printItems()
            self.isAdd = true
        }) { Image(systemName: "plus") }
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptList()
    }
}
