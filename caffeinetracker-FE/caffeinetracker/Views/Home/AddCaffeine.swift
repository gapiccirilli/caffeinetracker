//
//  AddCaffeine.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/29/22.
//

import SwiftUI

struct AddCaffeine: View {
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    private var currentDateComponents: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
    }
    let tenantId = KeychainWrapper.standard.string(forKey: "TENANT-ID") ?? ""
    @StateObject private var createCaffeine = PostRequest()
    @State private var postObject = Caffeine()
    @State private var popUp = false
    @State private var beverage: String = ""
    @State private var amount: Int = 0
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "", message: "", bannerType: .Error)
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Form {
                    TextField("Beverage", text: $beverage)
                        .modifier(CaffeineTextField())
                    TextField("Amount", value: $amount, formatter: formatter)
                        .modifier(CaffeineTextField())
                }
                Spacer()
                Button(action: {
                    if amount == 0 || beverage == "" {
                        popUp = true
                    } else {
                        postObject.id = 1
                        postObject.beverage = self.beverage
                        postObject.amount = self.amount
                        postObject.month = currentDateComponents.month!
                        postObject.day = currentDateComponents.day!
                        postObject.year = currentDateComponents.year!
                        postObject.hour = currentDateComponents.hour!
                        postObject.minute = currentDateComponents.minute!
                        postObject.seconds = currentDateComponents.second!
                        // POST REQUEST
                        // RESPONSE OBJECT IS STORED IN createCaffeine object
                        createCaffeine.createCaffeine(caffeine: postObject, tenantId: tenantId, token: KeychainWrapper.standard.string(forKey: "JWT") ?? "NO TOKEN") { caffeineObj, errorDetails in
                            if let error = errorDetails {
                                bannerDetails = BannerData(title: "Error Adding", message: error.message, bannerType: .Error)
                                showBanner = true
                            } else {
                                if caffeineObj != nil {
                                    bannerDetails = BannerData(title: "Successfully Created!", message: "", bannerType: .Success)
                                    showBanner = true
                                    self.beverage = ""
                                    self.amount = 0
                                }
                            }
                        }
                    }
                }) {
                    Text("Submit")
                        .modifier(CaffeineButton())
                }
                .alert("Blank Field(s)", isPresented: $popUp, actions: {}, message: {
                    Text("All fields are required!")
                })
            }
            .multilineTextAlignment(.leading)
            .navigationTitle("Add Caffeine Log")
        }
        .banner(data: $bannerDetails, showBanner: $showBanner)
    }
}

struct AddCaffeine_Previews: PreviewProvider {
    static var previews: some View {
        AddCaffeine()
    }
}
