//
//  SearchVM.swift
//  iStocks
//
//  Created by Anton Tolstov on 27.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

class SearchStocksVM: ObservableObject {
    @Published private(set) var quotes: [Quote] = []
    
    @Published var searchText: String = "" { didSet { onTextChanged() } }
    @Published var selectedQuote: Quote?
    
    @Published var updatingError = false
    let updatingErrorTitle = "Quotes Unavailable"
    let updatingErrorMessage = "There may be a problem with the server or network. Plese try again later."
    
    private let count: Int
    private var filter: IStocksAPI.QuotesFilter!
    private var request: URLSessionDataTask?
    
    init(count: Int = 10, searchText: String = "") {
        self.count = count
        self.searchText = searchText
        
        onTextChanged()
    }
    
    func _load() {
        request?.cancel()
        request = IStocksAPI.quotes(for: filter) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    self.updatingError = false
                    self.quotes = quotes.sorted { $0.symbol < $1.symbol }
                case .failure(let reason):
                    switch reason {
                    case .canceled, .encodingError:
                        break
                    default:
                        self.updatingError = true
                    }
                }
            }
        }
    }
    
    private func onTextChanged() {
        self.filter = searchText == "" ? .all(count: count) : .search(for: searchText)
        _load()
    }
}
