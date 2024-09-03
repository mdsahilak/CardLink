//
//  BusinessCard.swift
//  CardLink
//
//  Created by Sahil Ak on 03/09/2024.
//

import Foundation
import CoreData

extension BusinessCard {
    /// The object's objectID returned in string representation
    var uniqueIdentifier: String {
        return objectID.uriRepresentation().absoluteString
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
    
    var phoneNumbers: [String] {
        get { phoneNumbers_?.components(separatedBy: "\n") ?? [] }
        set { phoneNumbers_ = newValue.joined(separator: "\n") }
    }
    
    var website: String {
        get { website_ ?? "" }
        set { website_ = newValue }
    }
    
    var address: String {
        get { address_ ?? "" }
        set { address_ = newValue }
    }
    
}
