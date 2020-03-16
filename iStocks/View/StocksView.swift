//
//  StocksView.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI
import Combine

struct StocksView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var token: Token?
    @ObservedObject var stocks: StocksVM
    
    init(token: Binding<Token?>) {
        self._token = token
        self.stocks = StocksVM(count: 8, token: token.wrappedValue!)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(searchText: self.$stocks.searchText)
                List {
                    ForEach(stocks.quotes, id: \.symbol.self) { quote in
                        NavigationLink(destination: Text("Quote")) {
                            QuoteRowView(quote: QuoteVM(quote: quote))
                        }
                    }
                    .onReceive(timer) { _ in self.stocks.refresh() }
                }
                
                NavigationLink(destination: Text("Porfolio")) {
                    Text("Portfolio")
                }
                .transition(.scale)
                .buttonStyle(MyButtonStyle())
                .padding(.horizontal)
                
                .navigationBarTitle("iStocks")
            }
            
            .onAppear() {
                self.stocks.refresh()
            }
        }
    }
}
