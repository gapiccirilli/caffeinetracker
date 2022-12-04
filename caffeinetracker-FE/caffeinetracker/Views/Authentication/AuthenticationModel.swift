//
//  AuthenticationModel.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/17/22.
//

import Foundation
import SwiftUI

extension ContentView {
    class AuthenticationModel: ObservableObject {
        @AppStorage("AUTH_TOGGLE") var isAuthenticated = false {
            willSet {objectWillChange.send()}
        }
        @AppStorage("USER_KEY") var username = "username"
        @Published var password = "password"
        @Published var invalid: Bool = false
        
        private var sampleUser = "username"
        private var samplePassword = "password"
        
        func toggleAuthentication() {
            self.password = ""
            
            withAnimation {
                isAuthenticated.toggle()
            }
        }
        
        func authenticate() {
            guard self.username.lowercased() == sampleUser else {
                self.invalid = true
                return
            }
            guard self.password.lowercased() == samplePassword else {
                self.invalid = true
                return
            }
            toggleAuthentication()
        }
        
        func logOut() {
            toggleAuthentication()
        }
    }
}
