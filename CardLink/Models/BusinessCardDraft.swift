//
//  BusinessCard.swift
//  CardLink
//
//  Created by Sahil Ak on 29/07/2024.
//

import Foundation

struct BusinessCardDraft: Identifiable {
    var id: UUID
    
    var company: String
    
    var name: String
    var role: String
    
    var email: String
    var phoneNumbers: [String]
    var website: String
    
    var address: String
}

extension BusinessCardDraft {
    static let mock: Self = BusinessCardDraft(
        id: UUID(),
        company: "Doom, Inc",
        name: "John Carmack",
        role: "Chief Engineer",
        email: "john@doom.com",
        phoneNumbers: ["+44 7585430111"],
        website: "www.doom.com",
        address: "#11, Antarctica 007007"
    )
}
