//
//  AssetsView.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct AssetsView: View {
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @ObservedObject var assets = AssetsVM()
    @ObservedObject var chart = ChartVM()
    @State var bool = false
    
    var body: some View {
        List {
            HStack {
                Text("Price")
                Spacer()
                Text("\(assets.portfolioPrice)")
            }
            .font(.title)
            
            HStack {
                Spacer()
                ChartView(chart: chart)
                    .frame(height: 250)
                Spacer()
            }
            
            Picker(selection: self.$chart.period,
                   label: Text("Period picker")) {
                    ForEach(IStocksAPI.ChartPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue)
                    }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            ForEach(assets.groups, id: \.quote.symbol) { assetGroup in
                NavigationLink(destination: Text("Not Implementd...")) {
                    AssetRowView(assetGroup)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .onDelete {
                self.assets.remove(at: $0)
            }
            .onReceive(timer) { _ in
                self.assets.load()
            }
            
            .buttonStyle(IStocksButtonStyle())
        }
        .navigationBarTitle("Assets", displayMode: .inline)
        .navigationBarItems(trailing:
            Button("Add") {
                self.assets.showingAddView = true
            }
        )
        .sheet(isPresented: $assets.showingAddView) {
            AddAssetView()
        }
        .onAppear() {
            self.chart.updating = self.assets.loadChart
        }
    }
    
}
