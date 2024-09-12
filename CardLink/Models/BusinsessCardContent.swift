//
//  BusinsessCardContent.swift
//  CardLink
//
//  Created by Sahil Ak on 06/09/2024.
//

import Foundation

// Helper model for saving draft data while editing a BusinessCard
struct BusinessCardContent: Codable, Identifiable {
    var id: String { "\(email) \(telePhone) \(mobilePhone)" }
    
    var name: String = ""
    
    var role: String = ""
    
    var organisation: String = ""
    
    var email: String = ""
    
    var telePhone: String = ""
    var mobilePhone: String = ""
    
    var website: String = ""
    
    var address: String = ""
}
