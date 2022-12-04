//
//  NumberAnimation.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/27/22.
//

import Foundation
import SwiftUI

struct NumberAnimation: AnimatableModifier {
    var number: CGFloat
    var animatableData: CGFloat {
        get {
            number
        }
        set {
            number = newValue
        }
    }
    
    func body(content: Content) -> some View {
        return content.overlay(Text("\(Int(number))"))
    }
}
