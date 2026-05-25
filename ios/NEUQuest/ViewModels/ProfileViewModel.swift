import Foundation
import Combine
import SwiftUI
import UIKit

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var editName: String = ""
    @Published var editCampus: String = ""
    @Published var editInterests: [String] = []
    @Published var isEditing: Bool = false
    @Published var isSaving: Bool = false
    @Published var showLogoutAlert: Bool = false
    @Published var showImagePicker: Bool = false
    @Published var selectedImage: UIImage?

    private let authService = AuthService.shared
    private let userService = UserService.shared

    var currentUser: User? { authService.currentUser }

    // MARK: - Start editing
    func startEditing() {
        guard let user = currentUser else { return }
        editName = user.name
        editCampus = user.campus
        editInterests = user.interests
        isEditing = true
    }

    // MARK: - Cancel editing
    func cancelEditing() {
        isEditing = false
    }

    // MARK: - Save profile
    func saveProfile() async {
        guard let user = currentUser else { return }
        isSaving = true
        try? await Task.sleep(nanoseconds: 300_000_000)
        _ = userService.updateProfile(
            user: user,
            name: editName.isEmpty ? user.name : editName,
            campus: editCampus.isEmpty ? user.campus : editCampus,
            interests: editInterests
        )
        isSaving = false
        isEditing = false
    }

    // MARK: - Toggle interest
    func toggleInterest(_ interest: String) {
        if editInterests.contains(interest) {
            editInterests.removeAll { $0 == interest }
        } else {
            editInterests.append(interest)
        }
    }

    // MARK: - Logout
    func logout() {
        authService.logout()
    }
}
