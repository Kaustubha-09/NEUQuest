import Foundation

// MARK: - NEU Campus
enum NEUCampus: String, CaseIterable, Codable {
    case boston = "Boston"
    case burlington = "Burlington"
    case charlotte = "Charlotte"
    case london = "London"
    case miami = "Miami"
    case online = "Online"
    case portland = "Portland"
    case seattle = "Seattle"
    case silicon = "Silicon Valley"
    case toronto = "Toronto"
    case vancouver = "Vancouver"
}

// MARK: - User Model
struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var campus: String
    var interests: [String]
    var profileImageURL: String
    var plannedTrips: [String]      // Trip IDs
    var eventsAttended: [String]    // Event IDs
    var isAdmin: Bool
    var isEmailVerified: Bool

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    var campusEnum: NEUCampus? { NEUCampus(rawValue: campus) }
}

// MARK: - Mock Users
extension User {
    static let mockCurrentUser = User(
        id: "user1",
        name: "Alex Husky",
        email: "alex.husky@husky.neu.edu",
        campus: "Boston",
        interests: ["Art", "Music", "Food", "Photography"],
        profileImageURL: "",
        plannedTrips: ["trip1"],
        eventsAttended: ["evt1"],
        isAdmin: false,
        isEmailVerified: true
    )

    static let mockAdminUser = User(
        id: "admin1",
        name: "NEU Admin",
        email: "admin@northeastern.edu",
        campus: "Boston",
        interests: [],
        profileImageURL: "",
        plannedTrips: [],
        eventsAttended: [],
        isAdmin: true,
        isEmailVerified: true
    )
}
