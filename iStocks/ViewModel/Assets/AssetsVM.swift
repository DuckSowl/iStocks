//
//  AssetsVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation
import SwiftUI

final class AssetsVM: ObservableObject {
    private(set) var groups: [AssetGroup] = []
    private var request: Request.DataTask?
    @Published var showingAddView = false
    
    init() { load() }
    
    var portfolioPrice: String {
        let price = groups.reduce(0.0, { $1.price + $0 })
        return price == 0 ? "" : "\(Int(price))"
    }
    
    func load() {
        if showingAddView { return }
        
        IStocksAPI.getAssets() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let assets):
                    self.setGroups(from: assets)
                    self.refreshQuotes()
                case .failure:
                    print("AssetsVM.load().failure")
                }
            }
        }
    }
    
    func refreshQuotes() {
        if showingAddView { return }

        let symbols = groups.map { $0.quote.symbol }
        
        request = IStocksAPI.quotes(for: .symbols(symbols)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    self.updateGroups(from: quotes)
                case .failure:
                    print("AssetsVM.refreshQuotes().failure")
                }
            }
        }
    }
    
    private func setGroups(from assets: [Asset]) {
        self.groups =
            Dictionary(grouping: assets, by: { $0.quote!.symbol })
                .map { _, assets in
                    let quote = assets.first!.quote!
                    return AssetGroup(
                        assets.map { Asset(id: $0.id,
                                           date: $0.date,
                                           price: $0.price) },
                        quote: quote) }
    }
    
    private func updateGroups(from quotes: [Quote]) {
        self.groups =
            self.groups
                .map { group in
                    let symbol = group.quote.symbol
                    let quote = quotes.first { $0.symbol == symbol }!
                    return AssetGroup(group.assets, quote: quote) }
                .sorted { $0.quote.symbol < $1.quote.symbol }
        self.objectWillChange.send()
    }
    
    deinit { request?.cancel() }
    
    func loadChart(period: IStocksAPI.ChartPeriod,
                   completion: @escaping (([Double]) -> ())) {
        IStocksAPI.chartOfAssets(within: period) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                completion([])
            }
        }
    }
    
    func remove(at offsets: IndexSet) {
        IStocksAPI.delete(assets: groups[offsets.first!].assets) { _ in }
        groups.remove(atOffsets: offsets)
    }
}
