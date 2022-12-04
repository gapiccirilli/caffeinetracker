//
//  Settings.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import SwiftUI

struct Settings: View {
    @AppStorage("auth") var isAuthenticated: Bool?
    @AppStorage("USERNAME") var loggedInUserName: String?
    @AppStorage("EMAIL") var loggedInUserEmail: String?
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                KeychainWrapper.standard.set("", forKey: "JWT")
                self.loggedInUserName = ""
                self.loggedInUserEmail = ""
                self.isAuthenticated = false
            }) {
                Text("Sign out")
                    .modifier(CaffeineButton())
                    .padding()
        }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
