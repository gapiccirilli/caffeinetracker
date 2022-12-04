//
//  Home.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import SwiftUI

struct Home: View {
    private var currentDateComponents: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([.year, .month, .day], from: Date())
    }
    @AppStorage("loadscreen") var isLoading = false
    @AppStorage("USERNAME") var loggedInUserName: String?
    let tenantId = KeyRetrieval.getTenantId()
    
    @StateObject var deleteCaffeine = DeleteRequest()
    @StateObject var dailyIntake = GetRequest()
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "", message: "", bannerType: .Error)
    
    var body: some View {
        NavigationView {
            VStack() {
                Text("Welcome, \(loggedInUserName ?? "User")!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.227, green: 0.183, blue: 0.079))
                
                    HStack {
                        Text("\(dailyIntake.intake.caffeineContent)mg")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 40)
                        
                        Spacer()
                        NavigationLink(destination: {
                            AddCaffeine()
                        }) {
                            Image(systemName: "plus")
                                .padding(.trailing, 50.0)
                                
                                .font(.system(size: 30))
                                .fontWeight(.heavy)
                                .foregroundColor(.brown)
                        }
                    }
                    
                    List {
                        if dailyIntake.intake.id == -1 || dailyIntake.intake.id == 0 {
                            CustomErrorMessageView(message: "No Caffeine Logs")
                                .padding(.horizontal, 80.0)
                        }
                        ForEach(dailyIntake.caffeine) { caffeine in
                            NavigationLink(destination: {UpdateView(coffee: caffeine)}) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Image(systemName: "cup.and.saucer")
                                        Text(caffeine.beverage)
                                    }
                                    .padding(0.5)
                                    HStack {
                                        Image(systemName: "bolt.square.fill")
                                        Text(" " + String(caffeine.amount) + "mg")
                                    }
                                    .padding(0.5)
                                    HStack {
                                        Image(systemName: "calendar.badge.clock")
                                        Text("\(caffeine.month)/\(caffeine.day)/\(String(caffeine.year)) \(caffeine.hour):\(caffeine.minute)")
                                    }
                                    .padding(0.5)
                                }
                            }
                        }
                        .onDelete(perform: { indexSet in
                            deleteItem(indexSet: indexSet)})
                        
                    }
                    .refreshable {
                        fetchData()
                    }
                }
            .onAppear() {
                fetchData()
        }
    }
        .banner(data: $bannerDetails, showBanner: $showBanner)
}
    func deleteItem(indexSet: IndexSet) {
        let caffeineId = dailyIntake.caffeine[indexSet.first!].id
        let deleteToken = KeychainWrapper.standard.string(forKey: "JWT")
        
        if let jwtToken = deleteToken {
            deleteCaffeine.deleteCaffeine(date: currentDateComponents, caffeineId: caffeineId, tenantId: tenantId ?? "", token: jwtToken) {}
            dailyIntake.caffeine.remove(atOffsets: indexSet)
            bannerDetails = BannerData(title: "Success", message: deleteCaffeine.deleteMessage, bannerType: .Success)
            showBanner = true
        } else {
            bannerDetails = BannerData(title: "Error", message: deleteCaffeine.deleteMessage, bannerType: .Error)
            showBanner = true
        }
        fetchData()
    }
    func fetchData() -> Void {
        isLoading = true
        if let jwtToken = KeychainWrapper.standard.string(forKey: "JWT"), let tenant = tenantId {
            dailyIntake.fetchIntakeByDate(date: currentDateComponents, tenantId: tenant, token: jwtToken) {}
            dailyIntake.fetchAllCaffeine(date: currentDateComponents, tenantId: tenant, token: jwtToken){
                isLoading = false
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
