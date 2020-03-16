//
//  ContentView.swift
//  iStocks
//
//  Created by Anton Tolstov on 12.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Group {
            if self.settings.token == nil {
                AuthenticationView(token: self.$settings.token)
            } else {
                StocksView(token: self.$settings.token)
            }
        }
    }
}
