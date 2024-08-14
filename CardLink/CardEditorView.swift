//
//  CardEditorView.swift
//  CardLink
//
//  Created by Sahil Ak on 14/08/2024.
//

import SwiftUI

struct CardEditorView: View {
    @State private var card: BusinessCard = .mock
    
    var body: some View {
        Form {
            Section("Image") {
                HStack {
                    Spacer()
                    Image("memoji_light")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .font(.appTitle1)
                    Spacer()
                }
            }
            
            Section("Full Name") {
                TextField("First Name", text: $card.firstName)
                TextField("Last Name", text: $card.lastName)
            }
            
            
            
            Section("Phone Number") {
                TextField("Phone", text: $card.phoneNumber)
            }
            
            Section("Email") {
                TextField("Email", text: $card.email)
            }
            
            Section("Address") {
                TextEditor(text: $card.address)
            }
        }
        .navigationTitle("Editor")
    }
}

#Preview {
    CardEditorView()
}
