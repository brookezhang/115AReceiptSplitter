//
//  Person.swift
//  FrontEnd
//
//  Created by Sibbons Shrestha on 2/5/22.
//

import SwiftUI

struct Person: Identifiable {
    let name: String
    let totalOwed: Int
    let id = UUID()
    init(name: String){
        self.name = name
        self.totalOwed = 0
    }
}

