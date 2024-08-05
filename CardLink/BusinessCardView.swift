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
            Color(red: 0.09, green: 0.63, blue: 0.52, opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("memoji_dark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 5))
                
                Text("Md Sahil Ak")
                    .font(.custom("Pacifico-Regular", size: 40))
                    .bold()
                    .foregroundColor(.white)
                
                Text("iOS Developer")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Divider()
                
                InfoView(infoText: "mdsahilak@gmail.com", iconName: "envelope.fill", iconColor: .green)
                InfoView(infoText: "+91 8747084769", iconName: "phone.fill", iconColor: .green)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 13)
                .foregroundStyle(Color(red: 0.09, green: 0.63, blue: 0.52, opacity: 1.00))
        }
        .frame(maxHeight: 250)
        .padding()
        
    }
}

#Preview {
    BusinessCardView(card: .mock)
}
