//
//  AssetRowView.swift
//  iStocks
//
//  Created by Anton Tolstov on 16.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct AssetRowView: View {
    let group: AssetGroupVM
    
    init(_ group: AssetGroup) {
        self.group = AssetGroupVM(group)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(group.symbol)
                    .font(.headline)
                Text(group.companyName)
                    .font(.subheadline)
            }
            Spacer()
            
            Text(group.priceChange)
                .foregroundColor(group.changeColor)
        }
    }
}
