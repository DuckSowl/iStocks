//
//  AddAssetView.swift
//  iStocks
//
//  Created by Anton Tolstov on 26.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct AddAssetView: View {
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var addAssetsVM: AddAssetVM = AddAssetVM()

    var body: some View {
        VStack {
            HStack {
                Text("Add Asset")
                    .font(.title)
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
            .padding()
                
            if self.addAssetsVM.selectedQuote == nil {
                SearchBarView(searchText: self.$addAssetsVM.searchText)
                List {
                    ForEach(addAssetsVM.quotes, id: \.symbol.self) { quote in
                        Button(action: {
                            withAnimation(.easeIn) {
                                self.addAssetsVM.selectedQuote = quote
                            }
                        }) {
                            QuoteRowView(quote)
                                .contentShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            } else {
                VStack {
                    Button("Reselect") {
                        self.addAssetsVM.selectedQuote = nil
                    }
                    .buttonStyle(IStocksButtonStyle())
                    .padding()
                    QuoteShortDetailView(self.addAssetsVM.selectedQuote!)
                    Spacer()
                }
            }
            
            DatePicker(selection: $addAssetsVM.date, in: ...Date(), displayedComponents: .date) {
                Text("Select a date")
            }
            .labelsHidden()
            
            TextField("purchace price", text: $addAssetsVM.purchacePrice)
                .keyboardType(.numberPad)
            
            Button("Add") {
                self.addAssetsVM.add()
            }
            .buttonStyle(IStocksButtonStyle())
            .padding()
            
        }
        .onReceive(timer) { _ in
            self.addAssetsVM._load()
        }
        .navigationBarTitle("Add Asset")
        
    }
}
