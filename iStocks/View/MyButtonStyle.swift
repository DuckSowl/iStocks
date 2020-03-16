//
//  MyButtonStyle.swift
//  iStocks
//
//  Created by Anton Tolstov on 10.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
     func makeBody(configuration: Self.Configuration) -> some View {
           configuration.label
               .padding()
               .frame(maxWidth: .infinity)
               .background(
                   RoundedRectangle(cornerRadius: 15)
                       .fill(Color.yellow)
               )
               .buttonStyle(PlainButtonStyle())
       }
}
