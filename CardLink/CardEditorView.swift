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
            Section("Name") {
                TextField("First Name", text: $card.name)
            }
            
            Section("Phone Number") {
                TextField("Phone", text: $card.phoneNumbers[0])
            }
            
            Section("Email") {
                TextField("Email", text: $card.email)
            }
            
            Section("Address") {
                TextEditor(text: $card.address)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Editor")
    }
}

#Preview {
    CardEditorView()
}
