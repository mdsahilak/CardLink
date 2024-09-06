//
//  NearbyExchangeView.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI

struct NearbyExchangeView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var model = NearbyExchangeViewModel()

    var body: some View {
        NavigationStack {
            List(model.peers) { peer in
                Button(action: {
                    model.connectTo(peer)
                }, label: {
                    HStack {
                        Image(systemName: "iphone.gen1")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)

                        Text(peer.peerId.displayName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 5)
                })
            }
            .onAppear {
                model.startBrowsing()
            }
            .onDisappear {
                model.finishBrowsing()
            }
            .alert(item: $model.permissionRequest, content: { request in
                Alert(
                    title: Text("Would you like to exchange cards with \(request.peerId.displayName)"),
                    primaryButton: .default(Text("Yes"), action: {
                        request.onRequest(true)
                    }),
                    secondaryButton: .cancel(Text("No"), action: {
                        request.onRequest(false)
                    })
                )
            })
            .sheet(item: $model.connectedPeer, content: { peer in
                NavigationStack {
                    VStack {
                        Text("Messages")
                        
                        Divider()
                        
                        ScrollView {
                            VStack {
                                ForEach(model.messages, id: \.self) { message in
                                    Text(message)
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button("Send Random Message") {
                            model.send(string: UUID().uuidString)
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    }
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(peer.peerId.displayName)
                        }
                    }
                }
                
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Searching for Peers")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "xmark")
                    }

                }
            }
        }
    }
}


#Preview {
    NearbyExchangeView()
}
