//
//  ContentView.swift
//  Gym-Tracker
//
//  Created by Shabbir Abedi on 2025-01-12.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var showingLoginView = false
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                DashboardView()
                    .transition(.opacity)
                    .onAppear {
                        print("DashboardView appeared - Auth state: \(authViewModel.isAuthenticated)")
                    }
                    .id("dashboard")
            } else {
                LoginView()
                    .transition(.opacity)
                    .onAppear {
                        print("LoginView appeared - Auth state: \(authViewModel.isAuthenticated)")
                    }
                    .id("login")
            }
            
            // Debug overlay
            VStack {
                Spacer()
                Text("Debug: \(authViewModel.debugMessage)")
                    .font(.caption)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            .allowsHitTesting(false)
        }
        .animation(.default, value: authViewModel.isAuthenticated)
        .onChange(of: authViewModel.isAuthenticated) { newValue in
            print("ContentView detected auth state change: \(newValue)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
