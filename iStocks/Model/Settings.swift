//
//  Settings.swift
//  iStocks
//
//  Created by Anton Tolstov on 12.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import Foundation

class Settings: ObservableObject {
    private let tokenKey = "tokenKey"
    
    @Published var token: Token? {
        didSet {
            if let data = try? JSONEncoder().encode(token) {
                UserDefaults.standard.set(data, forKey: tokenKey)
            }
        }
    }
    
    init() {
       if let data = UserDefaults.standard.data(forKey: tokenKey),
           let token = try? JSONDecoder().decode(Token.self, from: data) {
           self.token = token
       }
    }
}
