//
//  KeyRetrieval.swift
//  caffeinetracker
//
//  Created by Gino Piccirilli on 11/21/22.
//

import Foundation

class KeyRetrieval {
    
    static func getTenantId() -> String? {
        if let tenantId = KeychainWrapper.standard.string(forKey: "TENANT-ID") {
            return tenantId
        } else {
            return nil
        }
    }
}
