//
//  HapticController.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import UIKit

enum HapticController {
    static func send(force:  UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: force)
        generator.prepare()
        generator.impactOccurred()
    }
}
