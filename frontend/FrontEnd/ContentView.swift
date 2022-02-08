import SwiftUI

// Our observable object class
class Person: ObservableObject {
    @Published var nameList = [String]()
}

// A view that expects to find a GameSettings object
// in the environment, and shows its score.
struct ScoreView: View {
    @EnvironmentObject var persons: Person
    var body: some View {
        
            List{
                Section{
                    ForEach(persons.nameList, id:\.self) {item in
                        VStack(alignment: .leading){
                            Text(item).font(.headline)
                        }
                    }.onDelete(perform:{
                        indexSet in persons.nameList.remove(atOffsets:indexSet)
                    })
                }
            }
        }
    }



struct ContentView: View {
    @StateObject var persons = Person()
    //persons.nameList
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
                                persons.nameList.insert(text, at:0)
                                text = ""
                            }
                        }, label:{
                                Text("Add")
                        })
                    }
                }
                Section{
                    ForEach(persons.nameList, id:\.self) {item in
                        VStack(alignment: .leading){
                            Text(item).font(.headline)
                        }
                    }.onDelete(perform:{
                        indexSet in persons.nameList.remove(atOffsets:indexSet)
                    })
                }
                NavigationLink(destination: ScoreView()) {
                    Text("See Names in different view")
                }
            }.navigationTitle("Add Names")
        }.environmentObject(persons)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct ContentView: View {
//    @State var text: String = ""
//    @State var namesList = [String]()
//    var body: some View {
//        NavigationView{
//            List{
//                Section(header: Text("Enter New Name Below")){
//                    HStack{
//                        TextField("Peter Parker", text: $text)
//                        Button(action: {
//                            if !text.isEmpty{
//                                namesList.insert(text, at:0)
//                                text = ""
//                            }
//                        }, label:{
//                                Text("Add")
//                        })
//                    }
//                }
//                Section{
//                    ForEach(namesList, id:\.self) {item in
//                        VStack(alignment: .leading){
//                            Text(item).font(.headline)
//                        }
//                    }.onDelete(perform:{
//                        indexSet in namesList.remove(atOffsets:indexSet)
//                    })
//                }
//            }.navigationTitle("Add Names")
//        }
//    }
//
//}
