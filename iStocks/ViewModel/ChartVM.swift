//
//  ChartVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 22.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUILineChart

class ChartVM: ObservableObject {
    static let updatingErrorTitle = "Chart Unavailable"
    static let updatingErrorMessage = "There may be a problem with the server or network. Plese try again later."
    
    @Published private(set) var data: ChartData
    @Published var loading: Bool = false
    @Published var updatingError = false
    
    var updating: ((IStocksAPI.ChartPeriod, @escaping ([Double]) -> ()) -> ())? {
        didSet { update() }
    }
    
    var period = IStocksAPI.ChartPeriod.month {
        didSet { update() }
    }
    
    var style: LineChartStyle {
        return data.isEmpty ? .red
                                 : data.first! < data.last! ? .green
                                                                      : .red
    }
    
    typealias Ticks = [String]
    
    var verticalTicks: Ticks {
        guard !data.isEmpty else { return [] }
        
        let min = data.min()!
        let quater = (data.max()! - min) / 4
        return (1...4).map { "\(min + Double($0) * quater, decimalPlaces: 2)" }
    }
    
    var horizontalTicks: Ticks {
        guard !data.isEmpty else { return [] }
        
        let cal = Calendar.current
        let today = Date()
        switch period {
        case .week:
            return (1...6)
                .map { cal.date(byAdding: .day, value: -$0, to: today)! }
                .filter { !cal.isDateInWeekend($0) }
                .map { $0.day }
                .reversed()
        case .month:
            return (1...4)
                .map { cal.date(byAdding: .day, value: -7 * $0, to: today)!.day }
                .reversed()
        case .year:
            return (0...3)
                .map { cal.date(byAdding: .month, value: 4 * $0, to: today)!.month }
        }
    }
        
    init(chartData: ChartData = []) {
        self.data = chartData
    }
    
    private func update() {
        loading = true
        updatingError = false
        
        updating?(self.period) { data in
            DispatchQueue.main.async {
                self.loading = false
                if data.isEmpty {
                    self.updatingError = true
                } else {
                    self.data = data
                }
            }
        }
    }
}

private extension Date {
    var month: String {
        DateFormatter(dateFormat: "MMM").string(from: self)
    }
    
    var day: String {
        DateFormatter(dateFormat: "d").string(from: self)
    }
}
