//
//  BusinessCard+Helpers.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation

// Helpers for editing & saving functionality
extension BusinessCard {
    
    /// Get the contents of the core data model as a draft for editing.
    /// - Returns: A relevant details of the card as a Business Card Content
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
    
    
    /// Update the core data model class with the provided content information
    /// - Parameter content: The content to be updated on the Business Card
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
