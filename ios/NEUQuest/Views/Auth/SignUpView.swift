import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    headerSection
                    formSection
                        .padding(.horizontal, AppTheme.Spacing.lg)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                    }
                    .foregroundColor(AppTheme.Colors.brand)
                }
            }
        }
        .alert("Sign Up Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.clearErrors() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.brand)
                .padding(.top, AppTheme.Spacing.xl)

            Text("Join NEUQuest")
                .font(AppTheme.Typography.title1())
                .foregroundColor(AppTheme.Colors.textPrimary)

            Text("Create your Northeastern account")
                .font(AppTheme.Typography.subheadline())
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Full Name
            inputField(
                label: "Full Name",
                placeholder: "John Husky",
                icon: "person.fill",
                text: $viewModel.name
            )

            // NEU Email
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("NEU Email")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.leading, 4)
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                        .frame(width: 20)
                    TextField("yourname@husky.neu.edu", text: $viewModel.email)
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                .padding()
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                        .stroke(
                            viewModel.emailErrorMessage != nil ? AppTheme.Colors.error :
                            (!viewModel.email.isEmpty && viewModel.email.isValidNEUEmail ? AppTheme.Colors.success : AppTheme.Colors.divider),
                            lineWidth: 1
                        )
                )

                if let err = viewModel.emailErrorMessage {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.caption)
                        Text(err)
                    }
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(.leading, 4)
                } else if !viewModel.email.isEmpty && viewModel.email.isValidNEUEmail {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                        Text("Valid NEU email")
                    }
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.success)
                    .padding(.leading, 4)
                }
            }

            // Campus Picker
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text("Campus")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .padding(.leading, 4)
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                        .frame(width: 20)
                    Picker("Campus", selection: $viewModel.campus) {
                        ForEach(NEUCampus.allCases, id: \.rawValue) { campus in
                            Text(campus.rawValue).tag(campus.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(AppTheme.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                        .stroke(AppTheme.Colors.divider, lineWidth: 1)
                )
            }

            // Password
            passwordField(label: "Password", placeholder: "Min. 6 characters",
                          text: $viewModel.password, show: $showPassword,
                          validationMessage: viewModel.password.count < 6 && !viewModel.password.isEmpty
                            ? "Password must be at least 6 characters" : nil)

            // Confirm Password
            passwordField(label: "Confirm Password", placeholder: "Re-enter your password",
                          text: $viewModel.confirmPassword, show: $showConfirmPassword,
                          validationMessage: viewModel.passwordMismatchError)

            // Submit
            Button {
                Task { await viewModel.signUp() }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView().progressViewStyle(.circular).tint(.white)
                    } else {
                        Image(systemName: "person.badge.plus")
                        Text("Create Account")
                    }
                }
                .primaryButton()
            }
            .disabled(viewModel.isLoading || !viewModel.isSignUpValid)
            .opacity(viewModel.isSignUpValid ? 1.0 : 0.55)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isSignUpValid)
            .padding(.top, AppTheme.Spacing.sm)

            // NEU email notice
            HStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(AppTheme.Colors.brand)
                Text("Only @northeastern.edu and @husky.neu.edu emails are accepted")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.brand.opacity(0.08))
            .cornerRadius(AppTheme.Radius.md)
        }
        .padding(.bottom, AppTheme.Spacing.xxl)
    }

    // MARK: - Helpers
    @ViewBuilder
    private func inputField(label: String, placeholder: String, icon: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(label)
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.leading, 4)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .frame(width: 20)
                TextField(placeholder, text: text)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            .padding()
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(AppTheme.Colors.divider, lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func passwordField(label: String, placeholder: String,
                               text: Binding<String>, show: Binding<Bool>,
                               validationMessage: String?) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text(label)
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.leading, 4)
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .frame(width: 20)
                if show.wrappedValue {
                    TextField(placeholder, text: text)
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                } else {
                    SecureField(placeholder, text: text)
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                Button { show.wrappedValue.toggle() } label: {
                    Image(systemName: show.wrappedValue ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
            }
            .padding()
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(validationMessage != nil ? AppTheme.Colors.error : AppTheme.Colors.divider, lineWidth: 1)
            )

            if let msg = validationMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill").font(.caption)
                    Text(msg)
                }
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.error)
                .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
