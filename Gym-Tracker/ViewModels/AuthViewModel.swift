import SwiftUI
import AuthenticationServices

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showEmailSignIn = false
    
    private let authService = AuthService.shared
    
    init() {
        Task {
            isAuthenticated = await authService.currentSession != nil
        }
    }
    
    func signIn(email: String, password: String) {
        Task { [weak self] in
            await self?.handleAuth {
                try await self?.authService.signInWithEmail(email: email, password: password) ?? AuthResponse(user: nil, session: nil)
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Task { [weak self] in
            await self?.handleAuth {
                try await self?.authService.signUpWithEmail(email: email, password: password) ?? AuthResponse(user: nil, session: nil)
            }
        }
    }
    
    @MainActor
    private func handleAuth(_ operation: @escaping () async throws -> AuthResponse) async {
        isLoading = true
        do {
            let response = try await operation()
            isAuthenticated = response.session != nil
            showEmailSignIn = false
        } catch {
            self.error = error
        }
        isLoading = false
    }
} 
