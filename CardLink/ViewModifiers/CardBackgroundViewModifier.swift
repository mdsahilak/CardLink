//
//  CardBackgroundViewModifier.swift
//  CardLink
//
//  Created by Sahil Ak on 11/09/2024.
//

import SwiftUI

// View Modifier that applies a silver gradient card background
private struct CardBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundStyle(.gray.gradient.opacity(0.3))
            }
    }
}

// MARK: - Extension -
extension View {
    /// Apply a silver gradient card background to the view
    func cardBackground() -> some View {
        self.modifier(CardBackgroundViewModifier())
    }
}
