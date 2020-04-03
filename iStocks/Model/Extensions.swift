//
//  Extensions.swift
//  iStocks
//
//  Created by Anton Tolstov on 26.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUI

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Double, decimalPlaces: Int) {
        appendLiteral(String(format: "%.\(decimalPlaces)f", value))
    }
}

extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension Color {
    static var iStocksPrimary: Color { .blue }
}
