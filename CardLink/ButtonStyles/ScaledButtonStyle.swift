//
//  ScaledButtonStyle.swift
//  CardLink
//
//  Created by Sahil Ak on 09/09/2024.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
    let scaleFactor: CGFloat = 0.9
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleFactor : 1)
    }
}
