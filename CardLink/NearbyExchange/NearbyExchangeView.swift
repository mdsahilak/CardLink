//
//  NearbyExchangeView.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI

struct NearbyExchangeView: View {
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
                
                Divider()
                
                ForEach(model.messages, id: \.self) { message in
                    Text(message)
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
//                        model.show(peerId: request.peerId)
                    }),
                    secondaryButton: .cancel(Text("No"), action: {
                        request.onRequest(false)
                    })
                )
            })
            .sheet(item: $model.connectedPeer, content: { peer in
                Text(peer.peerId.displayName)
                VStack {
                    ForEach(model.messages, id: \.self) { message in
                        Text(message)
                    }
                }
                
                
                Button("Send Random Message") {
                    model.send(string: UUID().uuidString)
                }
                
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Searching for Peers")
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Send Hello") {
                        model.send(string: "Hello \(UUID().uuidString)")
                    }
                }
            }
        }
    }
}


#Preview {
    NearbyExchangeView()
}
