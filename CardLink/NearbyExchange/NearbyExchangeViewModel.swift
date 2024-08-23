//
//  NearbyExchangeViewModel.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI
import MultipeerConnectivity

@MainActor
final class NearbyExchangeViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let serviceType = "nearby-devices"
    private let browser: MCNearbyServiceBrowser
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    @Published var peers: [PeerDevice] = []
    
    override init() {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        browser.delegate = self
    }
    
    func startBrowsing() {
            browser.startBrowsingForPeers()
        }
        
        func finishBrowsing() {
            browser.stopBrowsingForPeers()
        }
}


extension NearbyExchangeViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
    
    struct PeerDevice: Identifiable, Hashable {
        let id = UUID()
        let peerId: MCPeerID
    }
}
