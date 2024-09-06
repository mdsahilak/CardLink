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
                        Text(card.organisation)
                            .font(.appTitle1)
                        
                        Text(card.name)
                            .font(.appTitle3)
                        
                        Text(card.role)
                            .font(.appCallout)
                        
                        Divider()
                        
                        Link(destination: URL(string: "maps://?address=\(card.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!) {
                            Text(card.address)
                                .multilineTextAlignment(.center)
                                .font(.appBody)
                        }
                        
                        Divider()
                        
                        Link(destination: URL(string: "mailto:\(card.email)")!) {
                            Text(card.email)
                                .font(.appBody)
                        }
                        
                        Divider()
                        
                        HStack {
                            Link(destination: URL(string: "tel:\(card.telePhone)")!) {
                                Text(card.telePhone)
                                    .font(.appBody)
                            }
                            
                            Divider()
                            
                            Link(destination: URL(string: "tel:\(card.telePhone)")!) {
                                Text(card.mobilePhone)
                                    .font(.appBody)
                            }
                        }
                        
                        Divider()
                        
                        if !card.website.isEmpty {
                            Link(destination: URL(string: "https://\(card.website)")!) {
                                Text(card.website)
                                    .font(.appBody)
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
