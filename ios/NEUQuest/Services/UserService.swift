import Foundation
import Combine

// MARK: - UserService
// NOTE: Replace UserDefaults with Firestore user document when Firebase SDK is added via SPM.
@MainActor
final class UserService: ObservableObject {
    static let shared = UserService()

    private init() {}

    // MARK: - Update profile
    func updateProfile(user: User, name: String, campus: String, interests: [String]) -> User {
        var updated = user
        updated.name = name
        updated.campus = campus
        updated.interests = interests
        AuthService.shared.updateUser(updated)
        return updated
    }

    // MARK: - Update profile image URL
    func updateProfileImageURL(user: User, url: String) -> User {
        var updated = user
        updated.profileImageURL = url
        AuthService.shared.updateUser(updated)
        return updated
    }

    // MARK: - Add trip to user
    func addTrip(tripID: String, to user: User) -> User {
        var updated = user
        if !updated.plannedTrips.contains(tripID) {
            updated.plannedTrips.append(tripID)
        }
        AuthService.shared.updateUser(updated)
        return updated
    }

    // MARK: - Remove trip from user
    func removeTrip(tripID: String, from user: User) -> User {
        var updated = user
        updated.plannedTrips.removeAll { $0 == tripID }
        AuthService.shared.updateUser(updated)
        return updated
    }

    // MARK: - Mark event attended
    func markEventAttended(eventID: String, user: User) -> User {
        var updated = user
        if !updated.eventsAttended.contains(eventID) {
            updated.eventsAttended.append(eventID)
        }
        AuthService.shared.updateUser(updated)
        return updated
    }

    // MARK: - All available interests
    static let allInterests: [String] = EventCategory.allCases.map { $0.rawValue } + [
        "Hiking", "Technology", "Science", "History", "Wellness", "Yoga",
        "Dance", "Theater", "Gaming", "Fashion", "Volunteering", "Networking"
    ]
}
