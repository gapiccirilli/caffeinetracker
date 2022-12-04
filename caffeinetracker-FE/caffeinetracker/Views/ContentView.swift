//
//  ContentView.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPageIndex = 0
    @AppStorage("auth") var isAuthenticated: Bool?
    @AppStorage("loadscreen") var isLoading = false
    
    let tabBarNames = ["Home", "Calendar", "Analyze", "Settings"]
    let tabBarIcons = ["house.circle.fill", "calendar.circle.fill", "chart.xyaxis.line", "gearshape.2.fill"]
    
    var body: some View {
        
        ZStack {
            switch self.isAuthenticated {
                
            case false:
                Signin(resetToHome: $selectedPageIndex)
                
            case true:
                VStack {
                    
                    ZStack {
                        switch selectedPageIndex {
                        case 0:
                            Home()
                        case 1:
                            NavigationView {
                                CalendarView()
                                    .navigationTitle("Caffeine By Date")
                            }
                        case 2:
                            NavigationView {
                                Graph()
                                    .navigationTitle("Progress")
                            }
                        case 3:
                            NavigationView {
                                Settings()
                                    .navigationTitle("Settings")
                            }
                        default:
                            Text("Error")
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        ForEach(0..<4) { index in
                            Button(action: {
                                selectedPageIndex = index
                            }, label: {
                                Spacer()
                                VStack {
                                    Image(systemName: tabBarIcons[index])
                                        .font(.system(size: 30))
                                        .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.676, green: 0.482, blue: 0.394)/*@END_MENU_TOKEN@*/)
                                    Text(tabBarNames[index])
                                        .foregroundColor(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.676, green: 0.482, blue: 0.394)/*@END_MENU_TOKEN@*/)
                                }
                                Spacer()
                            }
                                   
                                   
                            )}
                    }
                    
                }
            default:
                Signin(resetToHome: $selectedPageIndex)
            }
        }
        .onAppear() {
            if isAuthenticated != nil {
                
            } else {
                isAuthenticated = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
