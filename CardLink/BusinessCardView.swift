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
        ZStack {
            Color.gray
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image("memoji_dark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                    
                    Text("Md Sahil Ak")
                        .font(.appSubheadline)
                        .bold()
                        .foregroundColor(.white)
                }
                
                Text("iOS Developer")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Divider()
                
                InfoView(infoText: "mdsahilak@gmail.com", iconName: "envelope.fill", iconColor: .green)
                InfoView(infoText: "+91 8747084769", iconName: "phone.fill", iconColor: .green)
            }
            .padding()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 7)
                .foregroundStyle(Color.gray)
        }
        .frame(maxHeight: 250)
        .padding()
        
    }
}

#Preview {
    BusinessCardView(card: .mock)
}
