//
//  ContentView.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 1/23/22.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    @State var namesList = [String]()
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("Enter New Name Below")){
                    HStack{
                        TextField("Peter Parker", text: $text)
                        Button(action: {
                            if !text.isEmpty{
                                namesList.insert(text, at:0)
                                text = ""
                            }
                        }, label:{
                                Text("Add")
                        })
                    }
                }
                Section{
                    ForEach(namesList, id:\.self) {item in
                        VStack(alignment: .leading){
                            Text(item).font(.headline)
                        }
                    }.onDelete(perform:{
                        indexSet in namesList.remove(atOffsets:indexSet)
                    })
                }
            }.navigationTitle("Add Names")
        }
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
