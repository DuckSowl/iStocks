//
//  QuoteDetailVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 25.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

class QuoteDetailVM: QuoteVM {
    
    var previousVolume : String { quote.previousVolume != nil ? "\(quote.previousVolume!)" : "-" }
    var marketCap      : String { quote.marketCap != nil ? "\(quote.marketCap!)" : "-" }
    var week52High     : String { quote.week52High != nil ? "\(quote.week52High!)" : "-" }
    var week52Low      : String { quote.week52Low != nil ? "\(quote.week52Low!)" : "-" }
    
    func loadChart(period: IStocksAPI.ChartPeriod,
                   completion: @escaping (([Double]) -> ())) {
        IStocksAPI.chart(for: symbol, within: period) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion([])
            }
        }
    }
}
