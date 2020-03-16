//
//  Request.swift
//  iStocks
//
//  Created by Anton Tolstov on 03.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Request {
    private static func getData(with url: URLRequest,
                                    completion: @escaping (Result<Data, RequestError>) -> ())  {
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
    
    static func getJSON<T: Decodable>(with urlRequest: URLRequest,
                                          type: T.Type,
                                          completion: @escaping (Result<T, RequestError>) -> ()) {
        getData(with: urlRequest, completion: { result in
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
    
    static func getJSON<T: Decodable>(with url: URL,
                                          type: T.Type,
                                          completion: @escaping (Result<T, RequestError>) -> ()) {
        getJSON(with: URLRequest(url: url), type: T.self) {
            completion($0)
        }
    }
    
    static func postJSON<P, R>(with urlRequest: URLRequest,
                               data: P? = nil,
                               responseType: R.Type,
                               completion: @escaping (Result<R, RequestError>) -> ())
        where P: Encodable, R: Decodable {
            var urlRequest = urlRequest
            
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            
            if data != nil {
                urlRequest.httpBody = try? JSONEncoder().encode(data)
                
                guard urlRequest.httpBody != nil else {
                    completion(.failure(.encodingError))
                    return
                }
            }
            
            getJSON(with: urlRequest, type: R.self) {
                completion($0)
            }
    }
    
    static func postJSON<R>(with urlRequest: URLRequest,
                            responseType: R.Type,
                            completion: @escaping (Result<R, RequestError>) -> ())
        where R: Decodable {
            let data: String? = nil
            postJSON(with: urlRequest, data: data, responseType: R.self) {
                completion($0)
            }
    }
    
    
    enum RequestError: Error {
        case networkError(error: Error)
        case missingData
        case decodingError
        case encodingError
    }
}
