//
//  BusinessCardView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct BusinessCardView: View {
    @ObservedObject var card: BusinessCard
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                Text(card.name)
                    .font(.appTitle2)
                
                Text(card.role)
                    .font(.appSubheadline)
                
                Text(card.organisation)
                    .font(.appFootnote)
            }
            
            Spacer()
            
            Image(systemName: "chevron.up")
                .imageScale(.small)
                .font(.appBody)
        }
        .padding(7)
    }
    
    private var IconView: some View {
        Image("memoji_light")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70, alignment: .center)
            .clipShape(Circle())
            .font(.appTitle1)
    }
}

