import Foundation
import Supabase
import AuthenticationServices

class AuthService {
    static let shared = AuthService()
    
    private let supabase: SupabaseClient
    
    init() {
        guard let projectURL = ProcessInfo.processInfo.environment["SUPABASE_URL"],
              let anonKey = ProcessInfo.processInfo.environment["SUPABASE_KEY"] else {
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
            supabaseURL: URL(string: projectURL)!,
            supabaseKey: anonKey
        )
        
        if let token = KeychainManager.shared.getSession(),
           let refreshToken = KeychainManager.shared.getRefreshToken() {
            Task {
                try? await supabase.auth.setSession(
                    accessToken: token,
                    refreshToken: refreshToken
                )
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
        let response = try await supabase.auth.signUp(
            email: email,
            password: password
        )
        
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
