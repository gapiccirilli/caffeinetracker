//
//  Test.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/23/22.
//

import SwiftUI

struct Test: View {
    private var coffee: Caffeine = Caffeine()
    init(coffee: Caffeine) {
        self.coffee = coffee
    }
    var body: some View {
        Text(coffee.beverage)
    }
}

