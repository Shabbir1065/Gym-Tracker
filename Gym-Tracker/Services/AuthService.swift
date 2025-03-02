import Foundation
import Supabase
import AuthenticationServices
import GoogleSignIn

class AuthService {
    static let shared = AuthService()
    
    private let supabase: SupabaseClient
    
    init() {
        // Use stored values or default test values if environment variables aren't available
        let projectURL = ProcessInfo.processInfo.environment["SUPABASE_URL"] ?? UserDefaults.standard.string(forKey: "SUPABASE_URL") ?? ""
        let anonKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] ?? UserDefaults.standard.string(forKey: "SUPABASE_KEY") ?? ""
        
        // Save to UserDefaults for subsequent app launches
        if !projectURL.isEmpty && !anonKey.isEmpty {
            UserDefaults.standard.set(projectURL, forKey: "SUPABASE_URL")
            UserDefaults.standard.set(anonKey, forKey: "SUPABASE_KEY")
        }
        
        guard !projectURL.isEmpty, !anonKey.isEmpty, let url = URL(string: projectURL) else {
            fatalError("""
                Missing Supabase configuration.
                Please set SUPABASE_URL and SUPABASE_KEY in your environment variables:
                
                1. Xcode → Edit Scheme → Run → Arguments → Environment Variables
                2. Add:
                   SUPABASE_URL = your_project_url
                   SUPABASE_KEY = your_project_key
                """)
        }
        
        supabase = SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
        
        // Initialize session from Keychain if available
        if let token = KeychainManager.shared.getSession(),
           let refreshToken = KeychainManager.shared.getRefreshToken() {
            Task {
                do {
                    try await supabase.auth.setSession(
                        accessToken: token,
                        refreshToken: refreshToken
                    )
                } catch {
                    print("Error restoring session: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var currentSession: Session? {
        get async {
            try? await supabase.auth.session
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthResponse {
        let response = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        
        let authSession = AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
        
        try KeychainManager.shared.saveSession(
            token: response.accessToken,
            refreshToken: response.refreshToken
        )
        
        return AuthResponse(
            user: User(
                id: response.user.id.uuidString,
                email: response.user.email,
                createdAt: response.user.createdAt
            ),
            session: authSession
        )
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> AuthResponse {
        // First attempt to sign up
        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )
        
        // If signup doesn't return a session, immediately sign in
        if response.session == nil {
            print("Signup successful but no session - attempting immediate sign in")
            return try await signInWithEmail(email: email, password: password)
        }
        
        let authSession = response.session.map { session in
            AuthSession(
                accessToken: session.accessToken,
                refreshToken: session.refreshToken
            )
        }
        
        if let session = response.session {
            try KeychainManager.shared.saveSession(
                token: session.accessToken,
                refreshToken: session.refreshToken
            )
        }
        
        return AuthResponse(
            user: User(
                id: response.user.id.uuidString,
                email: response.user.email,
                createdAt: response.user.createdAt
            ),
            session: authSession
        )
    }
    
    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws -> AuthResponse {
        guard let idToken = credential.identityToken,
              let token = String(data: idToken, encoding: .utf8) else {
            throw AuthError.invalidCredential
        }
        
        let response = try await supabase.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: token
            )
        )
        
        let authSession = AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
        
        try KeychainManager.shared.saveSession(
            token: response.accessToken,
            refreshToken: response.refreshToken
        )
        
        return AuthResponse(
            user: User(
                id: response.user.id.uuidString,
                email: response.user.email,
                createdAt: response.user.createdAt
            ),
            session: authSession
        )
    }
    
    func signInWithGoogle(presentingView: UIViewController) async throws -> AuthResponse {
        // Your iOS client ID (from Info.plist)
        let iOSClientID = "396119660338-mf09aj0k1qejdbbervj6d5ta9pdc2ktr.apps.googleusercontent.com"
        // Your Web Client ID (used by Supabase for verification)
        let webClientID = "396119660338-dbtm4f6vc9l01uoea3umb4346c7uumkl.apps.googleusercontent.com"

        // Set the configuration for the shared instance.
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: iOSClientID, serverClientID: webClientID)
        
        // Initiate the sign-in process using the presenting view controller.
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingView)
        
        // Extract the idToken from the result.
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.invalidCredential
        }
        
        // Pass nil explicitly for nonce since Google does not use one.
        let response = try await self.supabase.auth.signInWithIdToken(
            credentials: .init(
                provider: .google,
                idToken: idToken,
                nonce: nil
            )
        )
        
        // Save the session in the Keychain.
        let authSession = AuthSession(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
        try KeychainManager.shared.saveSession(
            token: response.accessToken,
            refreshToken: response.refreshToken
        )
        
        // Return the authenticated response.
        return AuthResponse(
            user: User(
                id: response.user.id.uuidString,
                email: response.user.email,
                createdAt: response.user.createdAt
            ),
            session: authSession
        )
    }


    
    func signOut() async throws {
        try await supabase.auth.signOut()
        try KeychainManager.shared.clearSession()
    }
}

enum AuthError: Error {
    case invalidCredential
    case emailNotVerified
    case passwordMismatch
} 
