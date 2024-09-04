//
//  PhoneNumber+CoreData.swift
//  CardLink
//
//  Created by Sahil Ak on 04/09/2024.
//

import Foundation
import CoreData

extension PhoneNumber {
    var value: String {
        get { value_ ?? "" }
        set { value_ = newValue }
    }
}
