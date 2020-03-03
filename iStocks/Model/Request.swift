//
//  Request.swift
//  iStocks
//
//  Created by Anton Tolstov on 03.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Request {
    static func requestData(with url: URL, completion: @escaping (Result<Data, RequestError>) -> ())  {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                return completion(.failure(.networkError(error: error!)))
            }
            
            guard let data = data else {
                return completion(.failure(.missingData))
            }
            
            return completion(.success(data))
        }.resume()
    }
    
    static func requestJSON<T>(with url: URL,
                               completion: @escaping (Result<T, RequestError>) -> ()) where T: Decodable {
        requestData(with: url, completion: { result in
            switch result {
            case .success(let data):
                if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(decoded))
                } else {
                    completion(.failure(.decodingError))
                }
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        })
    }
    
    enum RequestError: Error {
        case networkError(error: Error)
        case missingData
        case decodingError
    }
}
