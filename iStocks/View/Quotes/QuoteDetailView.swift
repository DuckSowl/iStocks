//
//  QuoteDetailView.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI
//import SwiftUILineChart

struct QuoteDetailView: View {
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var quote: QuoteDetailVM
    @ObservedObject private var chart = ChartVM()
    
    init(quote: Quote) {
        self.quote = QuoteDetailVM(quote)
        self.chart.updating = self.quote.loadChart
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(quote.symbol)
                    .font(.largeTitle)
                Text(quote.companyName)
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .buttonStyle(PlainButtonStyle())
            }

            HStack {
                Text(quote.latestPrice)
                    .font(.title)
                Spacer()
                Text(quote.change)
                    .font(.body)
                    .foregroundColor(quote.changeColor)
            }
            
            ChartView(chart: chart)
                .frame(height: 250)
            
            Picker(selection: self.$chart.period,
                   label: Text("Period picker")) {
                ForEach(IStocksAPI.ChartPeriod.allCases, id: \.self) { period in
                    Text(period.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            VStack {
                detailView("Vol", value: quote.previousVolume)
                horizontalSplit()
                detailView("Mkt Cap", value: quote.marketCap)
                horizontalSplit()
                detailView("52W H", value: quote.week52High)
                horizontalSplit()
                detailView("52W L", value: quote.week52Low)
            }
            
            Spacer()
        }
        .onReceive(timer) { _ in
            self.quote.load()
        }
        .padding()
    }
    
    func detailView(_ title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
    
    func horizontalSplit() -> some View {
        Rectangle()
            .strokeBorder(style:
                StrokeStyle(lineWidth: 1, dash: [4]))
            .frame(height: 1)
            .foregroundColor(.gray)
    }
}
