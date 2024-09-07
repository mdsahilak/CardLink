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
            HomeView()
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

#Preview {
    AppView()
}
