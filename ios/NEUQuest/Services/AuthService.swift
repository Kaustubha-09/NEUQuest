import Foundation
import Combine

// MARK: - AuthService
// NOTE: Replace mock storage with Firebase Auth when Firebase SDK is added via SPM.
// Pod: pod 'Firebase/Auth' or SPM: https://github.com/firebase/firebase-ios-sdk
@MainActor
final class AuthService: ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false

    private let userDefaultsKey = "neu_current_user"
    private let usersStorageKey = "neu_users_db"

    private init() {
        loadPersistedSession()
    }

    // MARK: - Load persisted session
    private func loadPersistedSession() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
            isAuthenticated = true
        }
    }

    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String, campus: String) async throws {
        isLoading = true
        defer { isLoading = false }

        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        guard email.isValidNEUEmail else {
            throw AuthError.invalidNEUEmail
        }

        guard password.count >= 6 else {
            throw AuthError.weakPassword
        }

        var usersDB = loadUsersDB()
        if usersDB.values.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            throw AuthError.emailAlreadyInUse
        }

        let newUser = User(
            id: UUID().uuidString,
            name: name,
            email: email,
            campus: campus,
            interests: [],
            profileImageURL: "",
            plannedTrips: [],
            eventsAttended: [],
            isAdmin: false,
            isEmailVerified: false  // Needs email verification
        )

        usersDB[newUser.id] = newUser
        saveUsersDB(usersDB)
        persistSession(newUser)
        currentUser = newUser
        isAuthenticated = true
    }

    // MARK: - Login
    func login(email: String, password: String) async throws {
        isLoading = true
        defer { isLoading = false }

        try await Task.sleep(nanoseconds: 800_000_000)

        guard email.isValidNEUEmail else {
            throw AuthError.invalidNEUEmail
        }

        // For demo: seed admin and mock user if DB is empty
        var usersDB = loadUsersDB()
        if usersDB.isEmpty {
            usersDB[User.mockCurrentUser.id] = User.mockCurrentUser
            usersDB[User.mockAdminUser.id] = User.mockAdminUser
            saveUsersDB(usersDB)
        }

        // Find user by email (mock password check: any non-empty password works)
        guard !password.isEmpty,
              let user = usersDB.values.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            throw AuthError.invalidCredentials
        }

        persistSession(user)
        currentUser = user
        isAuthenticated = true
    }

    // MARK: - Logout
    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        currentUser = nil
        isAuthenticated = false
    }

    // MARK: - Update user
    func updateUser(_ user: User) {
        var usersDB = loadUsersDB()
        usersDB[user.id] = user
        saveUsersDB(usersDB)
        persistSession(user)
        currentUser = user
    }

    // MARK: - Mark email verified (mock)
    func markEmailVerified() {
        guard var user = currentUser else { return }
        user.isEmailVerified = true
        updateUser(user)
    }

    // MARK: - Persistence helpers
    private func persistSession(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    private func loadUsersDB() -> [String: User] {
        guard let data = UserDefaults.standard.data(forKey: usersStorageKey),
              let db = try? JSONDecoder().decode([String: User].self, from: data) else {
            return [:]
        }
        return db
    }

    private func saveUsersDB(_ db: [String: User]) {
        if let data = try? JSONEncoder().encode(db) {
            UserDefaults.standard.set(data, forKey: usersStorageKey)
        }
    }
}

// MARK: - AuthError
enum AuthError: LocalizedError {
    case invalidNEUEmail
    case weakPassword
    case emailAlreadyInUse
    case invalidCredentials
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidNEUEmail:
            return "Please use your NEU email (@northeastern.edu or @husky.neu.edu)"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .invalidCredentials:
            return "Invalid email or password"
        case .unknown(let msg):
            return msg
        }
    }
}
