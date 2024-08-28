//
//  NearbyExchangeViewModel.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI
import MultipeerConnectivity
import Combine

@MainActor
final class NearbyExchangeViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let serviceType = "nearby-devices"
    private let browser: MCNearbyServiceBrowser
    
    @Published var peers: [PeerDevice] = []
    
    @Published var permissionRequest: PermitionRequest?
    
    @Published var connectedPeer: PeerDevice? = nil
    
    @Published var messages: [String] = []
//    let messagePublisher = PassthroughSubject<String, Never>()
//    var subscriptions = Set<AnyCancellable>()
    
    func send(string: String) {
        if let data = string.data(using: .utf8), let peerID = connectedPeer?.peerId{
            try? session.send(data, toPeers: [peerID], with: .reliable)
            
//            messagePublisher.send(string)
        } else {
            print("Error sendind data")
        }
    }
    
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
        advertiser.delegate = self
        session.delegate = self
        
//        messagePublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in
//                self?.messages.append($0)
//            }
//            .store(in: &subscriptions)
    }
    
    func startBrowsing() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
        
    func finishBrowsing() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
//    func show(peerId: MCPeerID) {
//        guard let first = peers.first(where: { $0.peerId == peerId }) else {
//            return
//        }
//        
//        joinedPeers.append(first)
//    }
    
    func connectTo(_ peer: PeerDevice) {
        if session.connectedPeers.contains(peer.peerId) {
            connectedPeer = peer
        } else {
            browser.invitePeer(peer.peerId, to: session, withContext: nil, timeout: 60)
        }
    }
}


extension NearbyExchangeViewModel: MCNearbyServiceBrowserDelegate {
    struct PeerDevice: Identifiable, Hashable {
        let id = UUID()
        let peerId: MCPeerID
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        peers.append(PeerDevice(peerId: peerID))
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}


extension NearbyExchangeViewModel: MCNearbyServiceAdvertiserDelegate {
    struct PermitionRequest: Identifiable {
        let id = UUID()
        let peerId: MCPeerID
        let onRequest: (Bool) -> Void
    }
    
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        permissionRequest = PermitionRequest(
            peerId: peerID,
            onRequest: { [weak self] permission in
                invitationHandler(permission, permission ? self?.session : nil)
            }
        )
    }
}

extension NearbyExchangeViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        return
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        return
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        return
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        return
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            self.messages.append(message)
        } else {
            print("Unable to decode message")
        }
        
//        guard let last = joinedPeers.last, last.peerId == peerID, let message = String(data: data, encoding: .utf8) else {
//            return
//        }

//        messagePublisher.send(message)
    }
}
