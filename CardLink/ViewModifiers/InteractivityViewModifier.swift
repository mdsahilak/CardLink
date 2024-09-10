//
//  InteractivityViewModifier.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI

/// Combo Modifier that disables and lightens out the view to signify that this view is not interactive at the moment
struct InteractivityViewModifier: ViewModifier {
    let isInteractive: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(isInteractive ? false : true)
            .opacity(isInteractive ? 1 : 0.3)
    }
}

// Convenience
extension View {
    func isInteractive(_ interactivity: Bool) -> some View {
        self.modifier(InteractivityViewModifier(isInteractive: interactivity))
    }
}
