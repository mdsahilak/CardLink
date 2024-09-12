//
//  PermissionRequest.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation
import MultipeerConnectivity

struct PermissionRequest: Identifiable {
    var id: MCPeerID { peerId }
    
    let peerId: MCPeerID
    let onRequest: (Bool) -> Void
}
