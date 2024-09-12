//
//  TappedButtonStyle.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI

/// Adds a background to the button on tap
struct TappedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(
                Color(.shadow)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .opacity(configuration.isPressed ? 1 : 0.01)
            )
    }
}
