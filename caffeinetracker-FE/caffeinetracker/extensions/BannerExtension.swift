//
//  BannerExtension.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/26/22.
//

import Foundation
import SwiftUI

extension View {
    func banner(data: Binding<BannerData>, showBanner: Binding<Bool>) -> some View {
        self.modifier(BannerNotification(data: data, showBanner: showBanner))
    }
}
