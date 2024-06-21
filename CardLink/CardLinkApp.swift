//
//  CardLinkApp.swift
//  CardLink
//
//  Created by Sahil Ak on 21/06/2024.
//

import SwiftUI

@main
struct CardLinkApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
