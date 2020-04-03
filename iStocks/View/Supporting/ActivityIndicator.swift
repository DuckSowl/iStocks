//
//  ActivityIndicator.swift
//  iStocks
//
//  Created by Anton Tolstov on 26.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI
import Foundation

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    init(isAnimating: Binding<Bool>,
         style: UIActivityIndicatorView.Style = .medium) {
        self._isAnimating = isAnimating
        self.style = style
    }

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView,
                      context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
