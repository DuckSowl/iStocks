//
//  IStocksAPI.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct IStocksAPI {
    private static let baseURL = "http://localhost:8080/"
    private static let apiURL = "\(baseURL)istocks/"
        
    static func register(user: User,
                         completion: @escaping (Result<Token, Request.RequestError>) -> ()) {
        let registerRequest = URLRequest(url: (URL(string: "\(apiURL)register"))!)
        
        Request.postJSON(with: registerRequest,
                         data: user,
                         responseType: Token.self) {
            completion($0)
        }
    }
    
    static func login(user: User,
                      completion: @escaping (Result<Token, Request.RequestError>) -> ()) {
        var loginRequest = URLRequest(url: (URL(string: "\(apiURL)login"))!)
        
        guard let loginString = "\(user.username):\(user.password)"
                                    .data(using: .utf8)?
                                    .base64EncodedString() else {
                completion(.failure(.encodingError))
                return
        }
    
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        Request.postJSON(with: loginRequest,
                         responseType: Token.self) {
            completion($0)
        }
    }
    
    static func getQuotes(token: Token,
                          for filter: QuotesFilter,
                          completion: @escaping (Result<[Quote], Request.RequestError>) -> ()) {
        
        var quotesRequest = URLRequest(url: (URL(string: "\(apiURL)stocks/\(filter.path.filter { !$0.unicodeScalars.contains(where: {!CharacterSet.urlPathAllowed.contains($0)}) })"))!)
        
        quotesRequest.authorize(with: token)
        
        Request.getJSON(with: quotesRequest,
                        type: [Quote].self) {
            completion($0)
        }
    }
                
    enum QuotesFilter {
        case all(count: Int)
        case search(for: String)
        
        fileprivate var path: String {
            switch self {
            case .all(let count):
                return "\(count)"
            case .search(let searchText):
                return "search/\(searchText)"
            }
        }
    }
}

fileprivate extension URLRequest {
    mutating func authorize(with token: Token) {
        self.addValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
    }
}
