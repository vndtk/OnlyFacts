import Foundation

struct User: Codable {
    let id: UUID
    var email: String
    var username: String?
}

struct UserProfile: Codable {
    let id: UUID
    let username: String?
}

