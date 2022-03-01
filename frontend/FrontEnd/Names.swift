//
//  Names.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 2/11/22.
//

import SwiftUI

class People: ObservableObject {
    @Published var nameList = [Person]()
}

struct Names: View {
    // @StateObject var persons = People()
    @EnvironmentObject var persons: People
    @State var text: String = ""
    var body: some View {
        // NavigationView{
            List{
                Section(header: Text("Enter New Name Below")){
                    HStack{
                        TextField("Peter Parker", text: $text)
                        Button(action: {
                            if !text.isEmpty{
                                let temp = Person(name: text)
                                persons.nameList.insert(temp, at:0)
                                text = ""
                            }
                        }, label:{
                                Text("Add")
                        })
                    }
                }
                Section{
                    ForEach(persons.nameList, id:\.id) {item in
                        VStack(alignment: .leading){
                            Text(item.name).font(.headline)
                        }
                    }.onDelete(perform:{
                        indexSet in persons.nameList.remove(atOffsets:indexSet)
                    })
                }
                NavigationLink(destination: ReceiptList()) {
                    Text("Drop people in the next screen")
                }
            }.navigationTitle("Add Names")
        // }
        // .environmentObject(persons)
        // .navigationViewStyle(.stack)
    }

}

struct Names_Previews: PreviewProvider {
    static var previews: some View {
        Names()
    }
}
