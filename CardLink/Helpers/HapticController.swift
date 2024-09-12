//
//  HapticController.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import UIKit

enum HapticController {
    
    /// Send haptic feedback to the user's device hardware
    /// - Parameter force: The level of force to relayed to the user
    static func send(force:  UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: force)
        generator.prepare()
        generator.impactOccurred()
    }
}
