import Foundation

struct User: Codable {
    let id: UUID
    var email: String
    var profile: UserProfile?
}

struct UserProfile: Codable {
    let id: UUID
    let username: String?
}

