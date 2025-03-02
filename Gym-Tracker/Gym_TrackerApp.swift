//
//  Gym_TrackerApp.swift
//  Gym-Tracker
//
//  Created by Shabbir Abedi on 2025-01-12.
//

import SwiftUI
import GoogleSignIn

@main
struct Gym_TrackerApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authViewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
