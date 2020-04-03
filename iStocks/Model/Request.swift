//
//  Request.swift
//  iStocks
//
//  Created by Anton Tolstov on 03.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

struct Request {
    typealias DataTask = URLSessionDataTask
    
    private static func getData(with url: URLRequest,
                                completion: @escaping (Result<Data, RequestError>) -> ())
                                ->  DataTask  {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                if (error! as NSError).code == NSURLErrorCancelled {
                    return completion(.failure(.canceled))
                }
                
                return completion(.failure(.networkError(error: error!)))
            }
            
            guard let data = data else {
                return completion(.failure(.missingData))
            }
            
            return completion(.success(data))
        }
        dataTask.resume()
        return dataTask
    }
    
    static func getJSON<T: Decodable>(with urlRequest: URLRequest,
                                      type: T.Type,
                                      completion: @escaping (Result<T, RequestError>) -> ())
                                      ->  DataTask  {
        getData(with: urlRequest, completion: { result in
            switch result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                if let decoded = try? jsonDecoder.decode(T.self, from: data) {
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
                                      completion: @escaping (Result<T, RequestError>) -> ())
                                      ->  DataTask {
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
        urlRequest.addJSONHeader()
        
        if data != nil {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.dateEncodingStrategy = .iso8601
            urlRequest.httpBody = try? jsonEncoder.encode(data)
            
            guard urlRequest.httpBody != nil else {
                completion(.failure(.encodingError))
                return
            }
        }
        
        _ = getJSON(with: urlRequest, type: R.self) {
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
    
    static func delete(with urlRequest: URLRequest,
                       completion: @escaping (Result<Void, RequestError>) -> ()) {
        var urlRequest = urlRequest
        urlRequest.httpMethod = "DELETE"
        
        _ = getData(with: urlRequest) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let requestError):
                completion(.failure(requestError))
            }
        }
    }
    
    enum RequestError: Error {
        case networkError(error: Error)
        case missingData
        case decodingError
        case encodingError
        case canceled
    }
}

extension URLRequest {
    mutating func addJSONHeader() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
