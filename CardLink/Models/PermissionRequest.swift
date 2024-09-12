//
//  PermissionRequest.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation
import MultipeerConnectivity

// Model representing a permission request on the reciever's device during a peer-to-peer transfer
struct PermissionRequest: Identifiable {
    var id: MCPeerID { peerId }
    
    let peerId: MCPeerID
    
    /// The operation to be completed on accept or denial of the request
    let onRequest: (Bool) -> Void
}
