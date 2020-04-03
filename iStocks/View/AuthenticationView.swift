//
//  AuthenticationView.swift
//  iStocks
//
//  Created by Anton Tolstov on 12.03.2020.
//  Copyright © 2020 Anton Tolstov. All rights reserved.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var isTokenSet: Bool
    
    @State private var user = User()
    @State private var showingAlert = false
    @State private var alertTitle = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("iStocks")
                    .font(.largeTitle)
            }
            
            VStack {
                TextField("Username", text: $user.username)
                Color.iStocksPrimary
                    .frame(height: 1)
                TextField("Password", text: $user.password)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.iStocksPrimary, lineWidth: 1))
            .padding(.horizontal)
            
            
            HStack(spacing: 16) {
                Button("Sign Up") {
                    if self.fieldsAreValid() {
                        self.register()
                    }
                }
                .buttonStyle(IStocksButtonStyle())
                
                Button("Sign In") {
                    if self.fieldsAreValid() {
                        self.login()
                    }
                }
                .buttonStyle(IStocksButtonStyle())
            }
            .padding()
            
        }.alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertTitle), message: nil, dismissButton: .default(Text("OK")))
        })
    }
    
    func fieldsAreValid() -> Bool {
        if self.user.username == "" {
            showAlert(title: "Fill username")
            return false
        } else if self.user.password == "" {
            showAlert(title: "Fill password")
            return false
        } else if self.user.username.count < 6 {
            showAlert(title: "Username is too short")
            return false
        } else if self.user.password.count < 6 {
            showAlert(title: "Password is too short")
            return false
        }
        
        return true
    }
    
    func showAlert(title: String) {
        self.alertTitle = title
        self.showingAlert = true
    }
    
    func login() {
        IStocksAPI.login(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isTokenSet = true
                    return
                case .failure:
                    self.showAlert(title: "Unable to login")
                }
            }
        }
    }
    
    func register() {
        IStocksAPI.register(user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isTokenSet = true
                    return
                case .failure:
                    self.showAlert(title: "Unable to register")
                }
            }
        }
    }
}
