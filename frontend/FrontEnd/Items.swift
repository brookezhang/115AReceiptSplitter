//
//  Items.swift
//  FrontEnd
//
//  Created by sidrah munir on 3/4/22.
//

import Foundation
import SwiftUI

class Items: ObservableObject {
//    let id = UUID()
//    @Published var itemsList: [Item] = [
//        Item(name: "testing1", price: 200, pplList: [String]()),
//        Item(name: "testing2", price: 100, pplList: [String]()),
//    ]
    @Published var itemsList = [Item]()
    @Published var pplList = [Person]()
    @Published var subtotal: Double = 0.0
    
    func makeList(){
        self.pplList = [Person]()

        var pplDict: [String: Person] = [:]
        self.itemsList.forEach { i in
            i.peopleList.forEach{ p in
                let keyExists = pplDict[p] != nil
                if !keyExists{
                    pplDict[p] = Person(name: p)
                }
                pplDict[p]?.totalAdd(amount: round((i.price / Double(i.peopleList.count)) * 100) / 100)
            }

        }
        //loop through dict and add it to a list b/c swiftui can't print out dicts, sad
        for key in pplDict.keys {
            //print("\(key), \(String(describing: self.pplDict[key]?.totalOwed))")
            let temp = Person(name: key, amount: Double(pplDict[key]!.totalOwed))
            self.pplList.append(temp)
        }
        print("FROM CLASS FUNC \(self.pplList)")
    }
    
    func printItems() {
        self.itemsList.forEach { i in
            print (i.name)
        }
    }
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
