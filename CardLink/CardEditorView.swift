//
//  CardEditorView.swift
//  CardLink
//
//  Created by Sahil Ak on 14/08/2024.
//

import SwiftUI

struct CardEditorView: View {
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Business Card")
        }
    }
}

//#Preview {
//    CardEditorView()
//}
