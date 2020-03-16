//
//  QuoteVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUI

class QuoteVM: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var symbol = "-"
    @Published var companyName = "-"
    @Published var latestPrice = "-"
    @Published var change = "-"
    
    private var quote: Quote {
        willSet { refresh() }
    }
    
    func refresh() {
        symbol = quote.symbol
        companyName = quote.companyName
        latestPrice = quote.latestPrice != nil ? "\(quote.latestPrice!)" : "-"
        change = quote.change != nil ? "\(quote.change!)" : "-"
        objectWillChange.send()
    }
    
    var changeColor: Color {
        if let change = quote.change {
            if change == 0.0 { return .black }
            return change > 0.0 ? .green : .red
        }
        return .black
    }
    
    init(quote: Quote) {
        self.quote = quote
        self.refresh()
    }
}

