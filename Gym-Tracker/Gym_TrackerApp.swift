//
//  Gym_TrackerApp.swift
//  Gym-Tracker
//
//  Created by Shabbir Abedi on 2025-01-12.
//

import SwiftUI

@main
struct Gym_TrackerApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
