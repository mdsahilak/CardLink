//
//  BusinessCardView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct BusinessCardView: View {
    let card: BusinessCard
    
    var body: some View {
        HStack {
            Divider()
            
            VStack(alignment: .center, spacing: 7) {
                Text(card.fullName)
                    .font(.appTitle2)
                
                Divider()
                
                Text(card.role)
                    .font(.appFootnote)
                
                Text(card.company)
                    .font(.appSubheadline)
            }
            
            Divider()
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

#Preview {
    Form {
        Section {
            BusinessCardView(card: .mock)
                .padding()
        }
    }
}
