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
                Section("Organisation") {
                    TextField("", text: $card.organisation)
                }
                
                Section("Name") {
                    TextField("", text: $card.name)
                }
                
                Section("Role") {
                    TextField("", text: $card.role)
                }
                
                Section("Email") {
                    TextField("", text: $card.email)
                }
                
                Section("Phone Numbers") {
                    Button {
                        withAnimation {
                            let newNumber = PhoneNumber(context: context)
                            newNumber.value = ""
                            
                            withAnimation {
                                card.phoneNumbers.append(newNumber)
                            }
                        }
                    } label: {
                        Label("Add Phone Number", systemImage: "plus")
                    }
                    
                    ForEach(card.phoneNumbers) { phoneNumber in
                        if let index = card.phoneNumbers.firstIndex(of: phoneNumber) {
                            TextField("", text: $card.phoneNumbers[index].value)
                        }
                    }
                    .onDelete { offsets in
                        print(offsets)
                        print(card.phoneNumbers)
                        
                        withAnimation {
                            for offset in offsets {
                                print("offset: \(offset)")
                                card.phoneNumbers.remove(at: offset)
                            }
                        }
                        print(offsets)
                        print(card.phoneNumbers)
                    }
                }
                
                Section("Website") {
                    TextField("", text: $card.website)
                }
                
                Section("Address") {
                    TextEditor(text: $card.address)
                        .frame(minHeight: 100)
                }
            }
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
