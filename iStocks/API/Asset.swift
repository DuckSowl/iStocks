//
//  Asset.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Asset: Codable {
    var id = UUID()
    
    var quote: Quote?
    var date: Date
    var price: Double
}
