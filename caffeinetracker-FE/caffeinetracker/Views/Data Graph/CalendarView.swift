//
//  Graph.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//
// use binded date to send in GET request to get caffeine
// submissions for entire month

import SwiftUI

struct CalendarView: View {
    let calendar = Calendar(identifier: .gregorian)
    @StateObject var caffeine = GetRequest()
    
    @AppStorage("loadscreen") var isLoading = false
    @AppStorage("auth") var isAuthenticated: Bool?
    
    @StateObject var deleteCaffeine = DeleteRequest()
    @State private var date = Date()
    let tenantId = KeyRetrieval.getTenantId()
    
    @State private var showBanner: Bool = false
    @State private var bannerDetails = BannerData(title: "", message: "", bannerType: .Error)
    
    var body: some View {
       
        NavigationView {
            VStack {
                    
                    DatePicker("Select Date", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .onChange(of: date) {value in
                            isLoading = true
                            if let jwtToken = KeychainWrapper.standard.string(forKey: "JWT") {
                                caffeine.fetchAllCaffeine(date: calendar.dateComponents([.month, .year, .day], from: date), tenantId: tenantId ?? "", token: jwtToken) {
                                    isLoading = false
                                }
                            } else {
                                self.isAuthenticated = false
                            }
                            
                        }
                        
                    
                    Text(date.formatted(date: .complete, time: .omitted))
                        .font(.title3)
                        .padding(.top, -15)
                    
                if !caffeine.caffeineErrorFlag {
                    List {
                   
                            ForEach(caffeine.caffeine) { caf in
                                    NavigationLink (destination: UpdateView(coffee: caf)) {
                                        VStack(alignment: .leading) {
                                                    HStack {
                                                        Image(systemName: "cup.and.saucer")
                                                        Text(caf.beverage)
                                                    }
                                                    .padding(0.5)
                                                    HStack {
                                                        Image(systemName: "bolt.square.fill")
                                                        Text(" " + String(caf.amount) + "mg")
                                                    }
                                                    .padding(0.5)
                                                    HStack {
                                                        Image(systemName: "calendar.badge.clock")
                                                        Text("\(caf.month)/\(caf.day)/\(String(caf.year)) \(caf.hour):\(caf.minute)")
                                                    }
                                                    .padding(0.5)
                                        }
                                    }
                                
                                }
                                .onDelete(perform: {
                                    indexSet in
                                    deleteItem(indexSet: indexSet)
                                })
                                    
                                    
                                }
                                .onAppear() {
                                    
                                    fetchData()
                            }
                                .refreshable {
                                    fetchData()
                            }
                } else {
                    CustomErrorMessageView(message: caffeine.errorResponse.message)
                }
                    
                    
            }
            .banner(data: $bannerDetails, showBanner: $showBanner)
        }
        
    }
    func deleteItem(indexSet: IndexSet) {
        let caffeineId = caffeine.caffeine[indexSet.first!].id
        let deleteToken = KeychainWrapper.standard.string(forKey: "JWT")
        
        if let jwtToken = deleteToken {
            deleteCaffeine.deleteCaffeine(date: calendar.dateComponents([.month, .year, .day], from: date), caffeineId: caffeineId, tenantId: tenantId ?? "", token: jwtToken) {}
            caffeine.caffeine.remove(atOffsets: indexSet)
            bannerDetails = BannerData(title: "Success", message: deleteCaffeine.deleteMessage, bannerType: .Success)
            showBanner = true
        } else {
            bannerDetails = BannerData(title: "Error", message: deleteCaffeine.deleteMessage, bannerType: .Error)
            showBanner = true
            self.isAuthenticated = false
        }
        
    }
    func fetchData() -> Void {
        if let tenantId = KeychainWrapper.standard.string(forKey: "TENANT-ID"), let jwtToken = KeychainWrapper.standard.string(forKey: "JWT") {
            isLoading = true
            caffeine.fetchAllCaffeine(date: calendar.dateComponents([.month, .year, .day], from: date), tenantId: tenantId, token: jwtToken) {
                isLoading = false
            }
        } else {
            self.isAuthenticated = false
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}





//[Caffeine(id: 1, beverage: "Cold Brew", amount: 250, month: "10", day: "24", year: "2022", hour: "12", minute: "45", seconds: "55"), Caffeine(id: 2, beverage: "Matcha", amount: 95, month: "10", day: "24", year: "2022", hour: "1", minute: "29", seconds: "32")]
