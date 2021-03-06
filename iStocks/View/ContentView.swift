//
//  ContentView.swift
//  iStocks
//
//  Created by Anton Tolstov on 12.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    private let tokenKey = "tokenKey"
    @State var isTokenSet: Bool = false
    
    var body: some View {
        Group {
            if self.isTokenSet {
                StocksView(isTokenSet: $isTokenSet)
            } else {
                AuthenticationView(isTokenSet: $isTokenSet)
            }
        }.onAppear() {
            self.loadToken()
        }
    }
    
    func loadToken() {
        if let token = UserDefaults.standard.string(forKey: self.tokenKey) {
            IStocksAPI.set(token: token)
            isTokenSet = true
        }
    }
    
   
}
