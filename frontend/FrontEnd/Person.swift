import SwiftUI

struct Person: Identifiable {
    let name: String
    var totalOwed: Double
    let id = UUID()
    init(name: String, amount: Double = 0){
        self.name = name
        self.totalOwed = amount
    }
    mutating func totalAdd(amount: Double){
        self.totalOwed += amount
    }
}
