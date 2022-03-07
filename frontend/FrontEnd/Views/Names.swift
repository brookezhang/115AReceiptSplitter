//
//  Names.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 2/11/22.
//

import SwiftUI

class People: ObservableObject {
    @Published var nameList = [String]()
}

struct Names: View {
    @EnvironmentObject var persons: People
    @State var inputStr: String = ""
    @State private var empty = true
    
    var body: some View {
            List{
                Section(header: Text("Enter New Name Below")){
                    HStack{
                        TextField("Peter Parker", text: $inputStr)
                        Button(action: {
                            if !inputStr.isEmpty{
                                let inputStrTrimmed = inputStr.trimmingCharacters(in: .whitespacesAndNewlines)

                                guard !persons.nameList.contains(inputStrTrimmed) else {
                                    inputStr = ""
                                    return
                                }
                                persons.nameList.insert(inputStrTrimmed, at:0)
                                if persons.nameList.count >= 1{
                                    empty = false
                                }
                                inputStr = ""
                            }
                        }, label:{
                                Text("Add")
                        })
                    }
                }
                Section{
                    ForEach(persons.nameList, id:\.self) {name in
                        VStack(alignment: .leading){
                            Text(name).font(.headline)
                        }
                    }.onDelete(perform:{
                        indexSet in persons.nameList.remove(atOffsets:indexSet)
                        if persons.nameList.count == 0{
                            empty = true
                        }
                    })
                }
                NavigationLink(destination: ReceiptList()) {
                    Text("Drop people in the next screen")
                }.disabled(empty)
            }.navigationTitle("Add Names")

    }

}

struct Names_Previews: PreviewProvider {
    static var previews: some View {
        Names()
    }
}
