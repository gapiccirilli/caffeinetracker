//
//  Caffeine.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 10/24/22.
//

import Foundation

class Caffeine: Codable, Identifiable {
    
    var id: Int
    var beverage: String
    var amount: Int
    var month: Int
    var day: Int
    var year: Int
    var hour: Int
    var minute: Int
    var seconds: Int
    
    init(id: Int, beverage: String, amount: Int, month: Int, day: Int, year: Int, hour: Int, minute: Int, seconds: Int) {
        self.id = id
        self.beverage = beverage
        self.amount = amount
        self.month = month
        self.day = day
        self.year = year
        self.hour = hour
        self.minute = minute
        self.seconds = seconds
    }
    
    init () {
        self.id = 0
        self.beverage = "beverage"
        self.amount = 0
        self.month = 0
        self.day = 0
        self.year = 0
        self.hour = 0
        self.minute = 0
        self.seconds = 0
    }
    
    init(beverage: String, amount: Int, month: Int, day: Int, year: Int, hour: Int, minute: Int, seconds: Int) {
        self.id = 0
        self.beverage = beverage
        self.amount = amount
        self.month = month
        self.day = day
        self.year = year
        self.hour = hour
        self.minute = minute
        self.seconds = seconds
    }
}
