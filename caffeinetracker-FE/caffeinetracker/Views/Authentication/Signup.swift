//
//  Signup.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import SwiftUI

struct Signup: View {
    @Environment(\.presentationMode) var dismissal
    
    @StateObject private var register = PostRequest()
    private let userDetails = RegisterModel()
    
    @State private var fieldAlert = false
    @State private var passwordAlert = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "", message: "", bannerType: .Error)
    
    var body: some View {
        VStack {
            Image("Caffeine_Tracker_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.bottom, -30)
            Text("Sign up!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.676, green: 0.482, blue: 0.394)/*@END_MENU_TOKEN@*/)
            HStack {
                Text("Already have an account?")
                    .foregroundColor(Color(hue: 1.0, saturation: 0.018, brightness: 0.541))
                Button(action: {
                    dismissal.wrappedValue.dismiss()
                }, label: {
                    Text("Log in!")
                        .foregroundColor(.purple)
                })
                
            }
            
            Form {
                Section {
                    TextField("First Name", text: $firstName)
                        .modifier(CaffeineTextField())
                    TextField("Last Name", text: $lastName)
                        .modifier(CaffeineTextField())
                } header: {
                    Text("First & Last Name")
                }
                
                Section {
                    TextField("Username", text: $username)
                        .modifier(CaffeineTextField())
                    TextField("Email", text: $email)
                        .modifier(CaffeineTextField())
                    SecureField("Choose Password", text: $password)
                        .modifier(CaffeineTextField())
                    SecureField("Confirm Password", text: $repeatPassword)
                        .modifier(CaffeineTextField())
                } header: {
                    Text("Username, Email & Password")
                }
            }
            .frame(width: 450.0)
            
            Button(action: {
                let passwordsMatch = password == repeatPassword && password != "" && repeatPassword != ""
                if !passwordsMatch {
                    bannerDetails = BannerData(title: "Registration Error", message: "Passwords must match!", bannerType: .Error)
                        self.showBanner = true
                    return
                }
                userDetails.firstName = self.firstName
                userDetails.lastName = self.lastName
                userDetails.userName = self.username
                userDetails.email = self.email
                userDetails.password = self.password
                self.password = ""
                self.repeatPassword = ""
                register.register(registerDetails: userDetails) { user, errorDetails in
                    if let error = errorDetails {
                    bannerDetails = BannerData(title: "Registration Error", message: error.message, bannerType: .Error)
                        self.showBanner = true
                    } else {
                        dismissal.wrappedValue.dismiss()
                    }
                }
            }, label: {
                Text("Sign up")
                    .modifier(CaffeineButton())
            })
        }
        .banner(data: $bannerDetails, showBanner: $showBanner)
    }
}

//struct Signup_Previews: PreviewProvider {
//    static var previews: some View {
//        Signup()
//    }
//}
