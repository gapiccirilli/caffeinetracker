//
//  UpdateView.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/31/22.
//

import SwiftUI

struct UpdateView: View {
    private var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
    // tenant ID
    let tenantId = KeyRetrieval.getTenantId()
    // Binded fields
    @State private var beverage: String = ""
    @State private var amount: Int = 0
    // pop up key for if no values are entered
    @State private var popUp = false
    // passed in caffeine object and object to be updated
    @State private var updateObject = Caffeine()
    private var caffeine = Caffeine()
    // Put Request API Call Object
    @StateObject private var update = PutRequest()
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "", message: "", bannerType: .Error)
    
    
    
    init(coffee: Caffeine) {
        self.caffeine = coffee
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField(caffeine.beverage, text: $beverage)
                            .modifier(CaffeineTextField())
                        TextField(String(caffeine.amount), value: $amount, formatter: formatter)
                            .modifier(CaffeineTextField())
                    }
                }
                Button(action: {
                    if amount == 0 || beverage == "" {
                        popUp = true
                    } else {
                        updateObject.id = caffeine.id
                        updateObject.beverage = self.beverage
                        updateObject.amount = self.amount
                        updateObject.month = caffeine.month
                        updateObject.day = caffeine.day
                        updateObject.year = caffeine.year
                        updateObject.hour = caffeine.hour
                        updateObject.minute = caffeine.minute
                        updateObject.seconds = caffeine.seconds
                        
                        update.updateCaffeine(caffeine: updateObject, caffeineId: updateObject.id, tenantId: tenantId ?? "No Tenant Id", token: KeychainWrapper.standard.string(forKey: "JWT") ?? "")
                        if let error = update.errorResponse {
                            self.bannerDetails = BannerData(title: "Update Error", message: error.message, bannerType: .Error)
                            self.showBanner = true
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
            .navigationTitle("Edit Caffeine Log")
        }
        .banner(data: $bannerDetails, showBanner: $showBanner)
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView(coffee: Caffeine())
    }
}
