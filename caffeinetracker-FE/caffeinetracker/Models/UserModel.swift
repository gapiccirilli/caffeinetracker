//
//  UserModel.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/20/22.
//

import Foundation

class UserModel: Codable, Identifiable {
    var id: Int = 0
    var tenantId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var userName: String = ""
    var email: String = ""
}
