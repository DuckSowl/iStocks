//
//  ChartView.swift
//  iStocks
//
//  Created by Anton Tolstov on 26.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI
import SwiftUILineChart

struct ChartView: View {
    @ObservedObject var chart: ChartVM

    var body: some View {
        ZStack {
            if chart.loading {
                ActivityIndicator(isAnimating: $chart.loading)
            } else {
                if chart.updatingError {
                    VStack {
                        Text(ChartVM.updatingErrorTitle)
                        Text(ChartVM.updatingErrorMessage)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                    .padding()
                } else {
                    LineChartView(data: chart.data,
                                  horizontalTicks: chart.horizontalTicks,
                                  verticalTicks: chart.verticalTicks,
                                  style: chart.style)
                }
            }
        }
    }
}
