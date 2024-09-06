//
//  WirelessShareViewModel.swift
//  CardLink
//
//  Created by Sahil Ak on 23/08/2024.
//

import SwiftUI
import MultipeerConnectivity
import Combine

@MainActor
final class WirelessShareViewModel: NSObject, ObservableObject {
    private let session: MCSession
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    
    @Published var peers: [MCPeerID] = []
    
    @Published var connectedPeer: MCPeerID? = nil
    
    @Published var messages: [String] = []
    
    @Published var permissionRequest: PermitionRequest?
    
    func send(string: String) {
        if let data = string.data(using: .utf8), let peer = connectedPeer {
            try? session.send(data, toPeers: [peer], with: .reliable)
            
        } else {
            print("Error sending data")
        }
    }
    
    override init() {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        let serviceType = Constants.wirelessShareServiceType
        
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
    }
    
    func startBrowsing() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
        
    func finishBrowsing() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func connectTo(_ peer: MCPeerID) {
        let card = BusinessCardContent(name: "Sahil Ak", role: "Engineer", organisation: "TimeWave")
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(card)
        
        browser.invitePeer(peer, to: session, withContext: data, timeout: 60)
        
//        if session.connectedPeers.contains(peer) {
//            connectedPeer = peer
//        } else {
//            let card = BusinessCardContent(name: "Sahil Ak", role: "Engineer", organisation: "TimeWave")
//            
//            browser.invitePeer(peer, to: session, withContext: nil, timeout: 60)
//        }
    }
}


extension WirelessShareViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !peers.contains(where: { $0 == peerID }) { peers.append(peerID) }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0 == peerID })
    }
}

extension WirelessShareViewModel: MCNearbyServiceAdvertiserDelegate {
    struct PermitionRequest: Identifiable {
        var id: MCPeerID { peerId }
        
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
                guard let self else { return }
                
                if permission {
                    let decoder = JSONDecoder()
                    
                    if let data = context, let card = try? decoder.decode(BusinessCardContent.self, from: data) {
                        print(card)
                    } else {
                        print("Invite decode error")
                    }
                }
                
                invitationHandler(false, session)
            }
        )
    }
}

extension MCPeerID: Identifiable {  }

extension WirelessShareViewModel: MCSessionDelegate {
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
            DispatchQueue.main.async {
                self.messages.append(message)
            }
        } else {
            print("Unable to decode message")
        }
    }
}
