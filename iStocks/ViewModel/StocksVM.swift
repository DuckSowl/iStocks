//
//  StocksVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUI

class StocksVM: ObservableObject {
    @Published private(set) var quotes: [Quote] = []
    @Published var searchText: String = "" {
        willSet {
            filter = newValue != "" ? .search(for: newValue) : .all(count: count)
        }
    }
    
    private var token: Token
    private var filter: IStocksAPI.QuotesFilter
    private let count: Int
    
    init(count: Int, token: Token) {
        self.count = count
        filter = .all(count: count)
        self.token = token
    }
    
    func refresh() {
        IStocksAPI.getQuotes(token: token, for: filter) { result in
            switch result {
            case .success(let quotes):
                DispatchQueue.main.async {
                    self.quotes = quotes.sorted { $0.symbol < $1.symbol }
                }
            case .failure(let reason):
                print("Quotes refresh failure with: \(reason)")
            }
        }
    }
}
