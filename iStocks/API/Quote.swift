//
//  Quote.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Quote: Codable {
    var symbol: String
    var companyName: String
    var latestPrice: Double?
    var change: Double?
    
    var previousVolume: Int?
    var marketCap: Int?
    var week52High: Double?
    var week52Low: Double?
}

typealias ChartData = [Double]
