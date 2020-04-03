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
    
    @Published private(set) var quote: Quote
    
    var symbol      : String { quote.symbol }
    var companyName : String { quote.companyName }
    var latestPrice : String { quote.latestPrice != nil ? "\(quote.latestPrice!)" : "-" }
    var change      : String {
        if let change = quote.change {
            return "\(change > 0 ? "+" : "")\(change, decimalPlaces: 2)"
        } else { return "-" }
    }
    
    var changeColor: Color {
        if let change = quote.change {
            if change == 0.0 { return .black }
            return change > 0.0 ? .green : .red
        }
        return .black
    }
    
    init(_ quote: Quote) {
        self.quote = quote
    }
    
    func load() {
        IStocksAPI.quote(for: symbol) { result in
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self.quote = quote
                }
            case .failure:
                return
            }
        }
    }
}

