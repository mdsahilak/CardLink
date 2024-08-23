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
                HStack {
                    Image(systemName: "iphone.gen1")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)

                    Text(peer.peerId.displayName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
            }
            .onAppear {
                model.startBrowsing()
            }
            .onDisappear {
                model.finishBrowsing()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Toggle("Press to be discoverable", isOn: $model.isAdvertised)
                        .toggleStyle(.switch)
                }
            }
        }
    }
}


#Preview {
    NearbyExchangeView()
}
