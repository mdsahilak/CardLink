//
//  WirelessShareView.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI
import MultipeerConnectivity

struct WirelessShareView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm = WirelessShareViewModel()
    
    @State private var showCardSelectorForPeer: MCPeerID? = nil
    
    @State private var showSelectCardError: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                RadarView()
                    .frame(maxHeight: 500)
                    .alert("Please Select a Card", isPresented: $showSelectCardError) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("OK")
                        }
                    }
                
                Divider()
                
                Text("Scanning for nearby devices...")
                    .font(.appCallout)
                    .italic()
                
                Divider()
                
                ScrollView {
                    ForEach(Array(vm.peers)) { peer in
                        Button(action: {
                            showCardSelectorForPeer = peer
                        }, label: {
                            HStack {
                                Spacer()
                                
                                Image(systemName: "antenna.radiowaves.left.and.right.circle.fill")
                                    .imageScale(.large)
                                    .font(.appTitle1)
                                    .foregroundColor(.accentColor)

                                Text(peer.displayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        })
                        .padding(7)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(.buttonBackground))
                        })
                        .padding()
                    }
                }
                .onAppear {
                    vm.startBrowsing()
                }
                .onDisappear {
                    vm.finishBrowsing()
                }
                .alert(item: $vm.permissionRequest, content: { request in
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
                .sheet(item: $showCardSelectorForPeer) { peer in
                    CardPickerView(vm: vm, peer: peer)
                }
                .sheet(item: $vm.acceptedContent) { content in
                    CardEditorView(type: .create, content: content) { editedContent in
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


struct CardPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: WirelessShareViewModel
    
    var peer: MCPeerID
    
    @FetchRequest(entity: BusinessCard.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \BusinessCard.timestamp_, ascending: false)], predicate: NSPredicate(format: "isTrashed_ == %@", NSNumber(value: false)), animation: .default)
    private var fetchedCards: FetchedResults<BusinessCard>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(fetchedCards) { card in
                        Button {
                            dismiss()
                            
                            vm.connectTo(peer, content: card.content())
                        } label: {
                            Text("\(card.organisation) - \(card.name) - \(card.role)")
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select the Card to Share")
        }
        .presentationDetents([.medium])
    }
}

