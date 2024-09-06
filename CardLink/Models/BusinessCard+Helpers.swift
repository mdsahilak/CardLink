//
//  BusinessCard.swift
//  CardLink
//
//  Created by Sahil Ak on 03/09/2024.
//

import Foundation
import CoreData

extension BusinessCard {
    var timestamp: Date {
        get { timestamp_ ?? Date() }
        set { timestamp_ = newValue }
    }
    
    // Properties Helpers
    var organisation: String {
        get { organisation_ ?? "" }
        set { organisation_ = newValue }
    }
    
    var name: String {
        get { name_ ?? "" }
        set { name_ = newValue }
    }
    
    var role: String {
        get { role_ ?? "" }
        set { role_ = newValue }
    }
    
    var email: String {
        get { email_ ?? "" }
        set { email_ = newValue }
    }
    
    var telePhone: String {
        get { telePhone_ ?? "" }
        set { telePhone_ = newValue }
    }
    
    var mobilePhone: String {
        get { mobilePhone_ ?? "" }
        set { mobilePhone_ = newValue }
    }
    
    var website: String {
        get { website_ ?? "" }
        set { website_ = newValue }
    }
    
    var address: String {
        get { address_ ?? "" }
        set { address_ = newValue }
    }
    
    
    // MARK:
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

//MARK: - Mock -
extension BusinessCard {
    /// Sample Card for use in SwiftUI Previews.
    static let previewCard: BusinessCard = {
        let card = BusinessCard(context: PersistenceController.preview.container.viewContext)
        
        card.organisation = "Apple, Inc"
        card.name = "John Appleseed"
        card.role = "Chief Demo Officer"
        
        return card
    }()
}
