//
//  CardViewer.swift
//  CardLink
//
//  Created by Sahil Ak on 04/09/2024.
//

import SwiftUI

struct CardViewer: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var card: BusinessCard
    
    @State private var showEditor: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .center, spacing: 7) {
                        Text(card.name)
                            .font(.appTitle2)
                        
                        Text(card.role)
                            .font(.appSubheadline)
                        
                        Text(card.organisation)
                            .font(.appFootnote)
                        
                        Divider()
                        
                        ForEach(card.phoneNumbers) { phoneNumber in
                            Link(destination: URL(string: "tel:\(phoneNumber.value)")!) {
                                Text(phoneNumber.value)
                                    .font(.appBody)
                            }
                                
                        }
                        
                        Link(destination: URL(string: "mailto:\(card.email)")!) {
                            Text(card.email)
                                .font(.appBody)
                        }
                        
                        if !card.address.isEmpty {
                            Divider()
                            
                            Link(destination: URL(string: "maps://?address=\(card.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!) {
                                Text(card.address)
                                    .multilineTextAlignment(.center)
                                    .font(.appBody)
                            }
                        }
                        
                        if !card.website.isEmpty {
                            Divider()
                            
                            Link(destination: URL(string: "https://\(card.website)")!) {
                                Text(card.website)
                                    .font(.appCallout)
                            }
                        }
                    }
                    .padding(7)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Label("Dismiss", systemImage: "chevron.down")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showEditor = true
                    }, label: {
                        Label("Edit", systemImage: "pencil")
                    })
                }
            }
            .sheet(isPresented: $showEditor, content: {
                CardEditorView(card: card)
            })
        }
    }
    
    private var IconView: some View {
        Image("memoji_light")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70, alignment: .center)
            .clipShape(Circle())
            .font(.appTitle1)
    }
}

#Preview {
    CardViewer(card: .previewCard)
}
