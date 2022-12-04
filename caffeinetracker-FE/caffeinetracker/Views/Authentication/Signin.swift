//
//  Signin.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import SwiftUI

struct Signin: View {
    @AppStorage("auth") var isAuthenticated: Bool?
    @AppStorage("USERNAME") var loggedInUserName: String?
    @AppStorage("EMAIL") var loggedInUserEmail: String?
    @AppStorage("loadscreen") var isLoading: Bool = false
    
    @StateObject private var login = PostRequest()
    @State private var loginCredentials = LoginModel()
    
    @Binding var resetToHome: Int
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "This is a test", message: "This is a test", bannerType: .Error)
    @State private var showSignUp = false
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        NavigationView {
                VStack {
                    Image("Caffeine_Tracker_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding(.bottom, -30)
                    Text("Log in")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.676, green: 0.482, blue: 0.394)/*@END_MENU_TOKEN@*/)
                            
                        
                    VStack {
                        TextField("Username", text: $username)
                            .modifier(CaffeineTextField())
                        SecureField("Password", text: $password)
                            .modifier(CaffeineTextField())
                        HStack {
                            Text("Don't have an account?")
                                .foregroundColor(Color(hue: 1.0, saturation: 0.018, brightness: 0.541))
                            Button(action: {
                                showSignUp = true
                            }, label: {
                                Text("Signup!")
                                    .foregroundColor(.purple)
                            })
                                
                        }
                            
                            
                        Button(action: {
//                            isLoading = true
                            loginCredentials.userName = self.username
                            loginCredentials.password = self.password
                            login.login(credentials: loginCredentials) { user, auth, errorDetails in
                                    
                                if let jwtToken = auth {
                                    resetToHome = 0
                                    self.loggedInUserName = user!.userName
                                    self.loggedInUserEmail = user!.email
                                KeychainWrapper.standard.set(jwtToken , forKey: "JWT")
                                KeychainWrapper.standard.set(user!.tenantId, forKey: "TENANT-ID")
                                    self.password = ""
                                    self.username = ""
                                    self.isAuthenticated = true
                                    isLoading = false
                                }
                                else {
                                    self.isAuthenticated = false
                                    bannerDetails = BannerData(title: "Login Error", message: errorDetails!.message, bannerType: .Error)
                                    showBanner = true
//                                    isLoading = false
                                }
                            }
                                
                        }) {
                            Text("Log in")
                                .modifier(CaffeineButton())
                                .padding()
                        }       
                    }
                    .padding()
                }
                .fullScreenCover(isPresented: $showSignUp, content: {Signup()})
            
        }
        .banner(data: $bannerDetails, showBanner: $showBanner)
    }
    func load(_ load: Bool) {
        if load {
            self.isLoading = true
        } else {
            self.isLoading = false
        }
    }
}

//struct Signin_Previews: PreviewProvider {
//    static var previews: some View {
//        Signin(resetToHome: <#Binding<Bool?>#>)
//    }
//}
