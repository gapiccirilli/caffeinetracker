//
//  Graph.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/25/22.
//

import SwiftUI
import Charts

struct Graph: View {
    @AppStorage("loadscreen") var isLoading = false
    @AppStorage("auth") var isAuthenticated: Bool?
    let calendar = Calendar(identifier: .gregorian)
    let tenantId = KeyRetrieval.getTenantId()
    @StateObject var intakes = GetRequest()
    @State private var startDate = Date()
    @State private var endDate = Date(timeIntervalSinceNow: 86400)
    
    
    var body: some View {
        
        VStack {
            if intakes.intakes.isEmpty {
                CustomErrorMessageView(message: "Your data will be shown here")
                    .padding(.horizontal)
            } else {
                Chart(intakes.intakes) { intake in
                    
                    BarMark (
                        x: .value("Days", intake.day),
                        y: .value("Caffeine (mg)", intake.caffeineContent)
                    )
                    .foregroundStyle(Color.purple)
                    
                }
                .frame(width: 400.0, height: 500)
            }
            
            DatePicker("Select Start Date:", selection: $startDate, displayedComponents: [.date])
                .frame(width: 400.0)
                .datePickerStyle(.compact)
                .font(.title2)
                .onChange(of: startDate) { _ in
                    fetchData()
                }
            DatePicker("Select End Date:", selection: $endDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .font(.title2)
                .frame(width: 400.0)
                .onChange(of: endDate) { _ in
                    fetchData()
                }
            
        }
        .onAppear {
            fetchData()
        }
    }
    func fetchData() -> Void {
        isLoading = true
        if let jwtToken = KeychainWrapper.standard.string(forKey: "JWT"), let tenant = tenantId {
            intakes.fetchAllIntakesInRange(startDate: calendar.dateComponents([.month, .day, .year], from: startDate), endDate: calendar.dateComponents([.month, .day, .year], from: endDate), tenantId: tenant, token: jwtToken) {
                isLoading = false
            }
        } else {
            self.isAuthenticated = false
        }
    }
}
    
    struct Graph_Previews: PreviewProvider {
        static var previews: some View {
            Graph()
        }
    }

