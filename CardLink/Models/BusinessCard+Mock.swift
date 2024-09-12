//
//  BusinessCard+Mock.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation

// Representation Card for use in SwiftUI Previews and Testing
extension BusinessCard {
    /// A mock card for testing
    static let mock: BusinessCard = {
        let card = BusinessCard(context: PersistenceController.preview.container.viewContext)
        
        card.organisation = "Apple, Inc"
        card.name = "John Appleseed"
        card.role = "Chief Demo Officer"
        
        return card
    }()
}
