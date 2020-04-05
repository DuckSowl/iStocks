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
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @ObservedObject var stocks = StocksVM()
    @Binding var isTokenSet: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: self.$stocks.searchText)
                List {
                    ForEach(stocks.quotes, id: \.symbol.self) { quote in
                        Button(action: { self.stocks.select(quote: quote) },
                               label: { QuoteRowView(quote) })
                    }
                    
                }
                NavigationLink(destination: AssetsView(),
                               isActive: $stocks.showingAssets) {
                    Text("Portfolio")
                }
                .buttonStyle(IStocksButtonStyle())
                .padding(.horizontal)

                .navigationBarItems(trailing: Button("Log Out") {
                    self.isTokenSet = false
                })
                .navigationBarTitle("iStocks")
                .alert(isPresented: self.$stocks.updatingError) {
                    Alert(title: Text(stocks.updatingErrorTitle),
                          message: Text(stocks.updatingErrorMessage),
                          dismissButton: .default(Text("OK")))
                }
                .sheet(isPresented: $stocks.showingDetail) {
                    QuoteDetailView(quote: self.stocks.selectedQuote!)
                }
                .onReceive(timer) { _ in
                    self.stocks.load()
                }
            }
        }
    }
}

