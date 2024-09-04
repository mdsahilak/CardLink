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
                    TextField("Apple, Inc.", text: $card.organisation)
                }
                
                Section("Name") {
                    TextField("John Appleseed", text: $card.name)
                }
                
                Section("Role") {
                    TextField("Chief Demo Officer", text: $card.role)
                }
                
                Section("Email") {
                    TextField("john.appleseed@apple.com", text: $card.email)
                }
                
                Section("Phone Numbers") {
                    Button {
                        withAnimation {
                            let newNumber = PhoneNumber(context: context)
                            newNumber.value = ""
                            
                            card.phoneNumbers.append(newNumber)
                        }
                    } label: {
                        Label("Add Phone Number", systemImage: "plus")
                    }
                    
                    ForEach(card.phoneNumbers) { phoneNumber in
                        if let index = card.phoneNumbers.firstIndex(of: phoneNumber) {
                            TextField("+12 34567890", text: $card.phoneNumbers[index].value)
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
                    TextField("https://www.apple.com", text: $card.website)
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
