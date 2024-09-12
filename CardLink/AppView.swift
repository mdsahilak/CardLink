//
//  AppView.swift
//  CardLink
//
//  Created by Sahil Ak on 05/09/2024.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            ScannerView(vm: ScannerViewModel())
                .tabItem {
                    Label("AI Scan", systemImage: "camera.aperture")
                }
            
            CardsListView()
                .tabItem {
                    Label("Cards", systemImage: "square.stack")
                }
            
            WirelessShareView()
                .tabItem {
                    Label("Wireless Share", systemImage: "shared.with.you")
                }
        }
    }
}
