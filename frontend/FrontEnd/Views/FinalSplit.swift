//
//  FinalSplit.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 3/1/22.
//

import SwiftUI
import Combine

struct RowNames: View{
    var body: some View{
        VStack(alignment: .leading, spacing: 15){
            Text("Subtotal: ")
            Text("Tax: ")
            Text("Tip: ")
            Text("Total: ").bold()
        }
    }
}

struct DollarSigns: View{
    var body: some View{
        VStack(alignment: .leading, spacing: 15){
            Text("$")
            Text("$")
            Text("$")
            Text("$")
        }
    }
}

struct FinalSplit: View {
    @StateObject var itemls: Items
    @State private var taxPercent = ""
    @State private var tipPercent = ""
    private enum Field: Int, CaseIterable {
        case amount
        case str
    }
    @FocusState private var focusedField: Field?
    var body: some View {
        let totalTax = itemls.subtotal * Double(convertToDouble(text: taxPercent)/100)
        let totalTip =  itemls.subtotal * Double(convertToDouble(text: tipPercent)/100)
        VStack{
            HStack{
                Spacer()
                VStack{
                    HStack{
                        Text("Tax Percent")
                        TextField("Enter here", text: $taxPercent).keyboardType(.decimalPad)
                            .onReceive(Just(taxPercent)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    self.taxPercent = filtered
                                }
                            }
                            .focused($focusedField, equals: .amount)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    Button("Done") {
                                        focusedField = nil
                                    }
                                }
                            }
                    }
                    HStack{
                        Text("Tip Percent")
                        TextField("Enter here", text: $tipPercent).keyboardType(.decimalPad)
                            .onReceive(Just(tipPercent)) { newValue in
                                let filtered = newValue.filter { "0123456789.".contains($0) }
                                if filtered != newValue {
                                    self.tipPercent = filtered
                                }
                            }
                            .focused($focusedField, equals: .amount)
                    }
                }
                Spacer()
                HStack(spacing: 10){
                    RowNames()
                    DollarSigns()
                    VStack(alignment: .leading, spacing: 15){
                        Text("\(String(format: "%.2f", itemls.subtotal))")
                        Text("\(String(format: "%.2f", totalTax))")
                        Text("\(String(format: "%.2f", totalTip))")
                        Text("\(String(format: "%.2f", itemls.subtotal + totalTax + totalTip))").bold()
                    }
                }
                Spacer()
                
            }
            List {
                Section {
                    ForEach(itemls.pplList){p in
                        let taxOwed = p.totalOwed * Double(convertToDouble(text: taxPercent)/100)
                        let tipOwed =  p.totalOwed * Double(convertToDouble(text: tipPercent)/100)
                        HStack{
                            Text("\(p.name)").font(.largeTitle)
                            Spacer()
                            HStack(spacing: 10){
                                RowNames()
                                DollarSigns()
                                VStack(alignment: .leading, spacing: 15){
                                    Text("\(String(format: "%.2f", p.totalOwed))")
                                    Text("\(String(format: "%.2f", taxOwed))")
                                    Text("\(String(format: "%.2f", tipOwed))")
                                    Text("\(String(format: "%.2f", p.totalOwed + taxOwed + tipOwed))").bold()
                                }
                            }
                        }
                    }
                }
            }
            // .listStyle(InsetListStyle())
        }
        .navigationTitle("Breakdown")
    }
    func convertToDouble(text: String?) -> Double {
        return Double(text ?? "0") ?? 0.0
    }
}
