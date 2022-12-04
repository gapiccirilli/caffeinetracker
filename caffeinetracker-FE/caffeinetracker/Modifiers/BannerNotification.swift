//
//  BannerNotification.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/26/22.
//

import Foundation
import SwiftUI

struct BannerNotification: ViewModifier {
    @Binding var data: BannerData
    @Binding var showBanner: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
            if showBanner {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.title)
                                .bold()
                            Text(data.message)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(12)
                    .background(data.bannerType.color)
                    .cornerRadius(8)
                    .frame(width: UIScreen.main.bounds.width - 25)
                    Spacer()
                }
                .padding()
                .animation(.easeIn, value: 4)
                .animation(.easeOut, value: 3)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                                withAnimation {
                                    self.showBanner = false
                                }
                    }.onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation {
                                self.showBanner = false
                            }
                        }
                    })
            }
        }
    }
}

struct BannerData {
    var title: String
    var message: String
    var bannerType: BannerType
}

enum BannerType {
    case Info
    case Success
    case Warning
    case Error
    
    var color: Color {
        switch self {
        case .Info:
            return Color(red: 50, green: 153, blue: 255)
        case .Success:
            return .green
        case .Warning:
            return .indigo
        case .Error:
            return .red
            
        }
    }
}
