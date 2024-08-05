//
//  HomeView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/08/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.63, blue: 0.52, opacity: 1.00)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("memoji_dark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: .center)
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
        
    }
}

struct InfoView: View {
    
    var infoText: String
    var iconName: String
    var iconColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1000)
            .fill(Color.white)
            .frame(height: 50)
            .overlay(HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                Text(infoText)
            })
            .padding(EdgeInsets(top: 16, leading: 12, bottom: 0, trailing: 12))
    }
    
}

#Preview {
    HomeView()
}
