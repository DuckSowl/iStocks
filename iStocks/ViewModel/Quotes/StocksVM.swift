//
//  StocksVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

final class StocksVM: SearchStocksVM {    
    @Published var showingDetail = false
    var showingAssets = false { didSet { objectWillChange.send() } }
    
    func select(quote: Quote) {
        super.selectedQuote = quote
        showingDetail = true
    }
    
    func load() {
        if showingAssets || showingDetail { return }
        _load()
    }
}
