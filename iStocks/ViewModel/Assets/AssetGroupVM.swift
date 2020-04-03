//
//  AssetGroupVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUI

struct AssetGroupVM {
    private var group: AssetGroup!
    
    var symbol         : String { group.quote.symbol }
    var companyName    : String { group.quote.companyName }
    var latestPrice    : String { group.quote.latestPrice != nil ? "\(group.quote.latestPrice!, decimalPlaces: 2)" : "-" }
    var change         : String { group.quote.change != nil ? "\(group.quote.change!, decimalPlaces: 2)" : "-" }
    var numberOfAssets : String { "\(group.assets.count)" }
    var price          : String { "\(group.price, decimalPlaces: 2)" }
    
    var priceChange:     String { group.priceChange != nil ? "\(group.priceChange!, decimalPlaces: 2)" : "-" }
    
    var changeColor: Color {
        if let change = group.priceChange {
            if change == 0.0 { return .black }
            return change > 0.0 ? .green : .red
        }
        return .black
    }
    
    init(_ group: AssetGroup) {
        self.group = group
    }
}

