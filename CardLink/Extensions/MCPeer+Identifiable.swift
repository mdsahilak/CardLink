//
//  MCPeer+Identifiable.swift
//  CardLink
//
//  Created by Sahil Ak on 12/09/2024.
//

import Foundation
import MultipeerConnectivity

// Make MCPeerID Identifiable so that the model can be used in SwifTUI ForEach loops
extension MCPeerID: Identifiable {  }
