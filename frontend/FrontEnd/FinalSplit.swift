//
//  FinalSplit.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 3/1/22.
//

import SwiftUI

class SplitTotals: ObservableObject{
    @Published var pplDict: [String: Person] = [:]
}

struct FinalSplit: View {
    @StateObject var itemls: Items
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10){
            ForEach(itemls.pplList){p in
                HStack{
                    Text("\(p.name)")
                    Text("Total Owed: $\(String(format: "%.2f", p.totalOwed))")

                }
            }
        }.padding(20)
    }
}
