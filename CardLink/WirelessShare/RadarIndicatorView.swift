//
//  RadarIndicatorView.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import SwiftUI

struct RadarIndicatorView: View {
    var size: CGSize
    
    // Constant(k) Referential Width and Height
    private let k: CGFloat = 350.0
    
    // Referential Ratio
    private var ratio: CGFloat {
        let num = min(size.width, size.height)
        return num / k
    }
    
    @State private var isRotating: Bool = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.heroBackground)
                .overlay(
                    Circle()
                        .stroke()
                        .foregroundColor(.shadow)
                )
                .padding()
            
            ring(width: 1, scale: 0.7)
            
            ring(width: 2, scale: 0.4)
            
            ring(width: 3, scale: 0.1)
            
            Rectangle()
                .frame(width: 150*ratio, height: 1.1*ratio, alignment: .center)
                .clipped(antialiased: true)
                .offset(x: 75*ratio)
                .rotationEffect(.degrees(isRotating ? 360 : 0))
            
            Circle()
                .frame(width: 7*ratio, height: 7*ratio, alignment: .center)
        }
        .rotationEffect(.degrees(-90))
        .onAppear {
            withAnimation(.linear(duration: 1.7).repeatForever(autoreverses: false)) {
                isRotating = true
            }
        }
    }
    
    private func ring(width: CGFloat, scale: CGFloat) -> some View {
        Circle()
            .stroke(lineWidth: width)
            .foregroundColor(.shadow)
            .padding()
            .scaleEffect(scale)
    }
}

