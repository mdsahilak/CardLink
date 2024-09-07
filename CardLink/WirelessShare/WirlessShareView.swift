//
//  WirlessShareView.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI

struct WirlessShareView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject var model = WirelessShareViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                RadarView()
                    .frame(maxHeight: 500)
                
                Divider()
                
                Text("Scanning for nearby devices...")
                    .font(.appCallout)
                    .italic()
                
                Divider()
                
                ScrollView {
                    ForEach(Array(model.peers)) { peer in
                        Button(action: {
                            model.connectTo(peer)
                        }, label: {
                            HStack {
                                Image(systemName: "iphone.gen1")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)

                                Text(peer.displayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 5)
                        })
                    }
                }
                .onAppear {
                    model.startBrowsing()
                }
                .onDisappear {
                    model.finishBrowsing()
                }
                .alert(item: $model.permissionRequest, content: { request in
                    Alert(
                        title: Text("Accept Business Card?"),
                        message: Text("Would you like to recieve a business card from \(request.peerId.displayName)?"),
                        primaryButton: .default(Text("Accept Business Card"), action: {
                            request.onRequest(true)
                        }),
                        secondaryButton: .cancel(Text("Decline"), action: {
                            request.onRequest(false)
                        })
                    )
                })
                .sheet(item: $model.acceptedContent) { content in
                    CardEditorView(content: content) { editedContent in
                        let newCard = BusinessCard(context: context)
                        newCard.timestamp = Date()
                        
                        newCard.update(with: editedContent)
                        
                        context.insert(newCard)
                        
                        try? context.save()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Wireless Share")
                        .font(.appTitle3)
                        .foregroundColor(.primaryText)
                }
            }
        }
    }
}


#Preview {
    WirlessShareView()
}
