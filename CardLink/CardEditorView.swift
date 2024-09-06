//
//  CardEditorView.swift
//  CardLink
//
//  Created by Sahil Ak on 14/08/2024.
//

import SwiftUI

struct CardEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var card: BusinessCard
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Full Name", text: $card.name)
                    TextField("Job Role", text: $card.role)
                    TextField("Organisation", text: $card.organisation)
                }
                
                Section("Email") {
                    TextField("Email Address", text: $card.email)
                }
                
                Section("Phone Numbers") {
                    HStack {
                        Text("T:")
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.7)
                            .frame(width: 25)
                            .foregroundStyle(.gray)
                        
                        Divider()
                        
                        TextField("", text: $card.telePhone)
                    }
                    
                    HStack {
                        Text("M:")
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.7)
                            .frame(width: 25)
                            .foregroundStyle(.gray)
                        
                        Divider()
                        
                        TextField("", text: $card.mobilePhone)
                    }
                }
                
                Section("Link") {
                    TextField("Website, Linkedin, Portfolio etc.", text: $card.website)
                }
                
                Section("Address") {
                    TextEditor(text: $card.address)
                        .frame(minHeight: 100)
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label("Dismiss", systemImage: "chevron.down")
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Edit Card")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
            }
        }
    }
}

//#Preview {
//    CardEditorView()
//}
