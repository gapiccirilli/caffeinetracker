//
//  CaffeineButton.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/29/22.
//

import Foundation
import SwiftUI

struct CaffeineButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 40)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.676, green: 0.482, blue: 0.394)/*@END_MENU_TOKEN@*/)
            .foregroundColor(.white)
            .cornerRadius(20.0)
    }
}
