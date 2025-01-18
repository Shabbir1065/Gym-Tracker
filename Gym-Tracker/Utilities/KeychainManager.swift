import Foundation
import KeychainAccess

class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = Keychain(service: "com.yourapp.gymtracker")
    
    func saveSession(token: String, refreshToken: String) throws {
        try keychain.set(token, key: "authToken")
        try keychain.set(refreshToken, key: "refreshToken")
    }
    
    func getSession() -> String? {
        try? keychain.get("authToken")
    }
    
    func getRefreshToken() -> String? {
        try? keychain.get("refreshToken")
    }
    
    func clearSession() throws {
        try keychain.remove("authToken")
        try keychain.remove("refreshToken")
    }
}