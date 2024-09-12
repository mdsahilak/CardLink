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
    
    var type: EditorType = .edit
    
    @State var content: BusinessCardContent
    
    var saveAction: (BusinessCardContent) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Full Name", text: $content.name)
                    TextField("Job Role", text: $content.role)
                    TextField("Organisation", text: $content.organisation)
                }
                
                Section("Email") {
                    TextField("Email Address", text: $content.email)
                }
                
                Section("Phone Numbers") {
                    HStack {
                        Text("T:")
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.7)
                            .frame(width: 25)
                            .foregroundStyle(.gray)
                        
                        Divider()
                        
                        TextField("", text: $content.telePhone)
                    }
                    
                    HStack {
                        Text("M:")
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.7)
                            .frame(width: 25)
                            .foregroundStyle(.gray)
                        
                        Divider()
                        
                        TextField("", text: $content.mobilePhone)
                    }
                }
                
                Section("Link") {
                    TextField("Website, Linkedin, Portfolio etc.", text: $content.website)
                }
                
                Section("Address") {
                    TextEditor(text: $content.address)
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
                        Label("Dismiss", systemImage: "xmark")
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    Text("\(type.rawValue.capitalized) Card")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        saveAction(content)
                        dismiss()
                    }, label: {
                        Label("Save", systemImage: "checkmark")
                    })
                }
            }
        }
    }
    
    enum EditorType: String {
        case edit
        case create
    }
}

