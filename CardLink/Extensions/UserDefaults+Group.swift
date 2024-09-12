//
//  UserDefaults+Group.swift
//  CardLink
//
//  Created by Sahil Ak on 10/09/2024.
//

import Foundation

// Common app group to be used between app targets
extension UserDefaults {
    static let group = UserDefaults(suiteName: Constants.InfoPlist.groupIdentifier)
}
