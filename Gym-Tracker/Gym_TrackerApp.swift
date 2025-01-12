//
//  Gym_TrackerApp.swift
//  Gym-Tracker
//
//  Created by Shabbir Abedi on 2025-01-12.
//

import SwiftUI

@main
struct Gym_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
