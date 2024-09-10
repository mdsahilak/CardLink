//
//  UserDefaults+Group.swift
//  CardLink
//
//  Created by Sahil Ak on 10/09/2024.
//

import Foundation

extension UserDefaults {
    static let group = UserDefaults(suiteName: Constants.InfoPlist.groupIdentifier)
}
