//
//  BusinessCard.swift
//  CardLink
//
//  Created by Sahil Ak on 29/07/2024.
//

import Foundation

struct BusinessCard {
    var firstName: String
    var lastName: String
    
    var email: String
    var phoneNumber: String
    
    var address: String
}

extension BusinessCard {
    static let mock: Self = BusinessCard(
        firstName: "James", 
        lastName: "Appleseed",
        email: "james@apple.com", 
        phoneNumber: "+44 7585430111",
        address: "#11, Antarctica 007007"
    )
}
