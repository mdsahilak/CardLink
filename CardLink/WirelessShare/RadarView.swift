//
//  RadarView.swift
//  CardLink
//
//  Created by Sahil Ak on 06/09/2024.
//

import SwiftUI

struct RadarView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    RadarIndicatorView(size: geometry.size)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
}
