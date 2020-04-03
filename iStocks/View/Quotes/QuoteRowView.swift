//
//  QuoteRowView.swift
//  iStocks
//
//  Created by Anton Tolstov on 13.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct QuoteRowView: View {
    let quote: QuoteVM
    
    init(_ quote: Quote) {
        self.quote = QuoteVM(quote)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(quote.symbol)
                    .font(.headline)
                Text(quote.companyName)
                    .font(.subheadline)
            }
            
            Spacer()
            VStack {
                Text(quote.latestPrice)
                Text(quote.change)
                    .foregroundColor(quote.changeColor)
            }
        }
    }
}

struct QuoteShortDetailView: View {
    let quote: QuoteVM
    
    init(_ quote: Quote) {
        self.quote = QuoteVM(quote)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(quote.symbol)
            Text(quote.companyName)
        }
        .font(.title)
    }
}
