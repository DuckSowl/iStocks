//
//  AssetGroup.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import Combine

struct AssetGroup {
    let assets: [Asset]
    var quote: Quote
    
    var price: Double {
        assets.reduce(0.0, { $0 + $1.price })
    }
    
    var priceChange: Double? {
        guard let latestPrice = quote.latestPrice else { return nil }
        return latestPrice * Double(assets.count) - price
    }
    
    init(_ assets: [Asset], quote: Quote) {
        self.assets = assets
        self.quote = quote
    }
}
