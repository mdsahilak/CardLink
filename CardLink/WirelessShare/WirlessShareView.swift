//
//  WirlessShareView.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI

struct WirlessShareView: View {
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
                    ForEach(model.peers) { peer in
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
