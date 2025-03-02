import SwiftUI
import AuthenticationServices

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: Error?
    @Published var showEmailSignIn = false
    @Published var debugMessage = "" // For debugging
    
    private let authService = AuthService.shared
    
    init() {
        Task {
            let session = await authService.currentSession
            await MainActor.run {
                self.isAuthenticated = session != nil
                self.debugMessage = "Init - Auth state: \(self.isAuthenticated)"
                print("Init - Auth state: \(self.isAuthenticated)")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Task {
            print("Starting sign in process for: \(email)")
            await self.handleAuth {
                try await self.authService.signInWithEmail(email: email, password: password)
            }
        }
    }
    
    func signUp(email: String, password: String) {
        Task {
            print("Starting sign up process for: \(email)")
            await self.handleAuth {
                try await self.authService.signUpWithEmail(email: email, password: password)
            }
        }
    }
    
    @MainActor
    private func handleAuth(_ operation: @escaping () async throws -> AuthResponse) async {
        isLoading = true
        debugMessage = "Auth operation started"
        print("Auth operation started")
        
        do {
            let response = try await operation()
            let hasSession = response.session != nil
            debugMessage = "Auth response received - Has session: \(hasSession)"
            print("Auth response received - Has session: \(hasSession)")
            
            isAuthenticated = hasSession
            showEmailSignIn = false
            
            debugMessage += " | Auth state updated: \(isAuthenticated)"
            print("Auth state updated: \(isAuthenticated)")
            
            print("Final authentication state after operation: \(self.isAuthenticated)")
        } catch {
            self.error = error
            debugMessage = "Auth error: \(error.localizedDescription)"
            print("Auth error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func signOut() {
        Task { [weak self] in
            guard let self = self else { return }
            
            print("Starting sign out process")
            self.debugMessage = "Starting sign out process"
            self.isLoading = true
            
            do {
                try await authService.signOut()
                await MainActor.run {
                    self.isAuthenticated = false
                    self.isLoading = false
                    self.debugMessage = "Sign out completed - Auth state: \(self.isAuthenticated)"
                    print("Sign out completed - Auth state: \(self.isAuthenticated)")
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                    self.debugMessage = "Sign out error: \(error.localizedDescription)"
                    print("Sign out error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        Task {
            print("Starting Google sign in process")
            await self.handleAuth {
                try await self.authService.signInWithGoogle(presentingView: presentingViewController)
            }
        }
    }
} 
