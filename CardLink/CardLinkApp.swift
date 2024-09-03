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
    
    init() {
        // Appearance Overrides
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemGray
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
