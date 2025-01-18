import Foundation

struct AuthResponse {
    let user: User?
    let session: AuthSession?
}

struct AuthSession: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
} 