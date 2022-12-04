//
//  CaffeineTextField.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/29/22.
//

import Foundation
import SwiftUI

struct CaffeineTextField: ViewModifier {
    let fieldColor: Color = Color(red: 0.337, green: 0.362, blue: 0.387, opacity: 0.259)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(fieldColor)
            .cornerRadius(15)
    }
}
