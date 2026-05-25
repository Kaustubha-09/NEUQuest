import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var name: String = ""
    @Published var campus: String = NEUCampus.boston.rawValue
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    private let authService = AuthService.shared

    // MARK: - Computed validation
    var isLoginValid: Bool {
        !email.isEmpty && !password.isEmpty && email.isValidNEUEmail
    }

    var isSignUpValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        email.isValidNEUEmail &&
        password.count >= 6 &&
        password == confirmPassword
    }

    var emailErrorMessage: String? {
        guard !email.isEmpty else { return nil }
        if !email.isValidEmail { return "Please enter a valid email" }
        if !email.isValidNEUEmail { return "Must be a @northeastern.edu or @husky.neu.edu email" }
        return nil
    }

    var passwordMismatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        return password != confirmPassword ? "Passwords do not match" : nil
    }

    // MARK: - Login
    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            try await authService.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }

    // MARK: - Sign Up
    func signUp() async {
        guard isSignUpValid else { return }
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signUp(name: name, email: email, password: password, campus: campus)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isLoading = false
    }

    // MARK: - Logout
    func logout() {
        authService.logout()
    }

    func clearErrors() {
        errorMessage = nil
        showError = false
    }
}
