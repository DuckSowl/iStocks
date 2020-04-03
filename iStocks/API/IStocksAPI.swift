//
//  IStocksAPI.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct IStocksAPI {
//    private static let baseURL = "https://istocks-back.herokuapp.com/"
    private static let baseURL = "http://localhost:8080/"
    private static let apiURL = "\(baseURL)istocks/"
    
    private(set) static var token: String?
        
    static func register(user: User,
                         completion: @escaping (Result<String, Request.RequestError>) -> ()) {
        let registerRequest = URLRequest(string: "\(apiURL)register")!
        
        Request.postJSON(with: registerRequest,
                         data: user,
                         responseType: Token.self) { result in
            completion(setToken(with: result))
        }
    }
    
    static func login(user: User,
                      completion: @escaping (Result<String, Request.RequestError>) -> ()) {
        var loginRequest = URLRequest(string: "\(apiURL)login")!
        
        guard let loginString = "\(user.username):\(user.password)"
                                    .data(using: .utf8)?
                                    .base64EncodedString() else {
            completion(.failure(.encodingError))
            return
        }
    
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        _ = Request.getJSON(with: loginRequest,
                            type: Token.self) { result in
            completion(setToken(with: result))
        }
    }
    
    static func set(token: String) {
        Self.token = token
    }
    
    private static func setToken(with result: Result<Token, Request.RequestError>)
                                 -> Result<String, Request.RequestError> {
        switch result {
        case .success(let token):
            Self.token = token.token
            return .success(Self.token!)
        case .failure(let reason):
            return .failure(reason)
        }
    }
        
    static func quotes(for filter: QuotesFilter,
                       completion: @escaping (Result<[Quote], Request.RequestError>) -> ())
                       ->  URLSessionDataTask? {
        let filter = filter.path.filterPathAllowed()
        guard filter != "search/" else {
            completion(.success([]))
            return nil
        }
                        
        let quotesRequest = URLRequest(string: "\(apiURL)stocks/\(filter)")!
        
        return Request.getJSON(with: quotesRequest,
                        type: [Quote].self) {
            completion($0)
        }
    }
    
    static func quote(for symbol: String,
                      completion: @escaping (Result<Quote, Request.RequestError>) -> ()) {
        let symbol = symbol.filterPathAllowed()
        guard symbol != "" else {
            completion(.failure(.encodingError))
            return
        }
        
        let quoteRequest = URLRequest(string: "\(apiURL)stocks/quote/\(symbol)")!
        
        _ = Request.getJSON(with: quoteRequest,
                        type: Quote.self) {
            completion($0)
        }
    }
    
    static func chart(for symbol: String,
                      within period: ChartPeriod,
                      completion: @escaping (Result<[Double], Request.RequestError>) -> ()) {
        let symbol = symbol.filterPathAllowed()
        guard symbol != "" else {
            completion(.failure(.encodingError))
            return
        }
        
        let chartRequest = URLRequest(string: "\(apiURL)stocks/chart/\(symbol)/\(period)")!
                
        _ = Request.getJSON(with: chartRequest,
                        type: [Double].self) {
            completion($0)
        }

    }
    
    static func chartOfAssets(within period: ChartPeriod,
                              completion: @escaping (Result<[Double], Request.RequestError>) -> ()) {
        guard let token = Self.token else { return }
        
        var chartRequest = URLRequest(string: "\(apiURL)assets/chart/\(period)")!
        chartRequest.authorize(with: token)
        
        _ = Request.getJSON(with: chartRequest,
                        type: [Double].self) {
            completion($0)
        }

    }
    
    enum ChartPeriod: String, CaseIterable {
        case week
        case month
        case year
    }
                
    enum QuotesFilter {
        case all(count: Int)
        case search(for: String)
        case symbols([String])
        
        fileprivate var path: String {
            switch self {
            case .all(let count):
                return "list/top/\(count)"
            case .search(let searchText):
                return "search/\(searchText)"
            case .symbols(let symbols):
                return "list/\(symbols.joined(separator: ","))"
            }
        }
    }
    
    static func getAssets(completion: @escaping (Result<[Asset], Request.RequestError>) -> ()) {
        
        guard let token = Self.token else { return }
        
        var assetsRequest = URLRequest(url: (URL(string: "\(apiURL)assets"))!)        
        assetsRequest.authorize(with: token)
        
        _ = Request.getJSON(with: assetsRequest,
                        type: [Asset].self) {
            completion($0)
        }
    }
    
    static func add(asset: Asset,
                    completion: @escaping (Result<[Asset], Request.RequestError>) -> ()) {
        
        guard let token = Self.token else { return }
        
        var postAssetsRequest = URLRequest(url: (URL(string: "\(apiURL)assets"))!)
        postAssetsRequest.authorize(with: token)
        
        Request.postJSON(with: postAssetsRequest,
                         data: [asset],
                         responseType: [Asset].self) {
            completion($0)
        }
    }
    
    static func delete(assets: [Asset],
                       completion: @escaping (Result<Void, Request.RequestError>) -> ()) {
        
        guard let token = Self.token else { return }
        
        var deleteAssetsRequest = URLRequest(url: (URL(string: "\(apiURL)assets/\(assets.first!.id)"))!)
        
        deleteAssetsRequest.authorize(with: token)
        
        Request.delete(with: deleteAssetsRequest) {
            completion($0)
        }
    }

}

fileprivate extension URLRequest {
    mutating func authorize(with token: String) {
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}

fileprivate extension String {
    func filterPathAllowed() -> String {
        self.filter { !$0.unicodeScalars.contains(where: {
            !CharacterSet.urlPathAllowed.contains($0)
        })}
    }
}

fileprivate extension URLRequest {
    init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }
}
