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
        NavigationLink {
            CardEditorView()
        } label: {
            HStack {
                IconView
                Divider()
                
                InfoView
                Spacer()
            }
        }

    }
    
    private var IconView: some View {
        Image("memoji_light")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70, alignment: .center)
            .clipShape(Circle())
            .font(.appTitle1)
    }
    
    private var InfoView: some View {
        VStack(alignment: .leading, spacing: 7) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Chief Executive Officer")
                    .font(.appFootnote)
                
                Text("John Appleseed")
                    .font(.appTitle2)
            }
            
            Divider()
            
            Text("Apple, Inc.")
                .font(.appSubheadline)

        }
    }
}

#Preview {
    BusinessCardView(card: .mock)
        .frame(maxHeight: 100)
        .padding()
}
