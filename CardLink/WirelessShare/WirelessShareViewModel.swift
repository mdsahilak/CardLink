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
    
    @Published var permissionRequest: PermissionRequest?
    @Published var acceptedContent: BusinessCardContent? = nil
    
    override init() {
        // Multi-Peer Connectivity Setup
        let peer = MCPeerID(displayName: UIDevice.current.name)
        let serviceType = Constants.InfoPlist.wirelessShareServiceType
        
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        // Assign delegates
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
    }
    
    /// Start browsing for peers and advertising self as a peer in the Peer-To-Peer Network
    func start() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    /// Stop browsing for peers and advertising self as a peer  in the Peer-To-Peer Network
    func stop() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    /// Connect to a specific peer that is available to connect
    /// - Parameters:
    ///   - peer: The peer to connect to
    ///   - content: The card content to be sent to the peer
    func connectTo(_ peer: MCPeerID, content: BusinessCardContent) {
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(content)
            
            browser.invitePeer(peer, to: session, withContext: data, timeout: 60)
        } catch {
            print(error)
        }
    }
}


// MARK: - MCSessionDelegate Conformance -
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


// MARK: - MCNearbyServiceBrowserDelegate Conformance -
extension WirelessShareViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !peers.contains(where: { $0 == peerID }) { peers.append(peerID) }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0 == peerID })
    }
}


// MARK: - MCNearbyServiceAdvertiserDelegate Conformance -
extension WirelessShareViewModel: MCNearbyServiceAdvertiserDelegate {
    struct PermissionRequest: Identifiable {
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
        permissionRequest = PermissionRequest(
            peerId: peerID,
            onRequest: { [weak self] permission in
                guard let self else { return }
                
                if permission {
                    let decoder = JSONDecoder()
                    
                    if let data = context, let content = try? decoder.decode(BusinessCardContent.self, from: data) {
                        DispatchQueue.main.async {
                            self.acceptedContent = content
                        }
                    } else {
                        print("Invite decode error")
                    }
                }
                
                invitationHandler(false, session)
            }
        )
    }
}

