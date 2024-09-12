//
//  BusinessCard+Helpers.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation

// MARK: Edit & Save Functionality
extension BusinessCard {
    func content() -> BusinessCardContent {
        BusinessCardContent(
            name: name,
            role: role,
            organisation: organisation,
            email: email,
            telePhone: telePhone,
            mobilePhone: mobilePhone,
            website: website,
            address: address
        )
    }
    
    func update(with content: BusinessCardContent) {
        name = content.name
        role = content.role
        organisation = content.organisation
        
        email = content.email
        
        telePhone = content.telePhone
        mobilePhone = content.mobilePhone
        
        website = content.website
        
        address = content.address
    }
    
}
