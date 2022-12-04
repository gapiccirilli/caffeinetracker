//
//  DailyIntake.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import Foundation

class DailyIntake: Codable, Identifiable {
    
    var id: Int
    var year: Int
    var month: Int
    var day: Int
    var caffeineContent: Int
    
    init() {
        self.id = 0
        self.year = 0
        self.month = 0
        self.day = 0
        self.caffeineContent = 0
    }
    
    init(id: Int, year: Int, month: Int, day: Int, caffeineContent: Int) {
        self.id = id
        self.year = year
        self.month = month
        self.day = day
        self.caffeineContent = caffeineContent
    }
}
