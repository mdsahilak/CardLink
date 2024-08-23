//
//  BusinessCard.swift
//  CardLink
//
//  Created by Sahil Ak on 29/07/2024.
//

import Foundation

struct BusinessCard: Identifiable {
    var id: UUID
    
    var firstName: String
    var lastName: String
    
    var fullName: String { "\(firstName) \(lastName)" }
    
    var role: String
    var company: String
    
    var email: String
    var phoneNumber: String
    
    var address: String
}

extension BusinessCard {
    static let mock: Self = BusinessCard(
        id: UUID(),
        firstName: "John",
        lastName: "Carmack",
        role: "Chief Engineer",
        company: "Doom, Inc",
        email: "john@doom.com",
        phoneNumber: "+44 7585430111",
        address: "#11, Antarctica 007007"
    )
}
