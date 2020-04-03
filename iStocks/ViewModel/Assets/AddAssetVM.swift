//
//  AddAssetVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 28.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

class AddAssetVM: SearchStocksVM {
    init() { super.init(count: 20) }
    
    var purchacePrice = ""
    var date: Date = Date()
    
    func add() {
        guard let price = Double(purchacePrice) else { return }
        
        let asset = Asset(quote: selectedQuote!, date: date, price: price)
        IStocksAPI.add(asset: asset) { _ in
            print("result of insertion")
        }
    }
}
