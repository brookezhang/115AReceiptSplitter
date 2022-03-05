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
    // @State var newPrice: Double
    
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
                Spacer()
                if (!item.peopleList.isEmpty) {
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



struct ReceiptList: View {

    //@ObservedObject var itemsTemp = Items()
    @EnvironmentObject var itemsTemp: Items
    @State var isCalc = false
    
    var body: some View {
        VStack {
            NamesView()
            NavigationLink(destination: FinalSplit(itemls: itemsTemp), isActive: $isCalc) {
                Button("Calculate Final Split") {
                    itemsTemp.makeList()
                    isCalc = true
                }
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
        }.navigationTitle("Drop names into items")
    }
}

struct ReceiptList_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptList()
    }
}
