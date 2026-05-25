import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showSignUp = false
    @State private var showPassword = false
    @State private var headerOpacity: Double = 0
    @State private var formOffset: CGFloat = 40
    @State private var formOpacity: Double = 0

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                scrollContent
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
        }
        .alert("Login Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.clearErrors() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.1)) { headerOpacity = 1 }
            withAnimation(.spring(response: 0.6).delay(0.2)) {
                formOffset = 0
                formOpacity = 1
            }
        }
    }

    // MARK: - Scroll Content
    private var scrollContent: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerSection
                    .opacity(headerOpacity)

                formSection
                    .offset(y: formOffset)
                    .opacity(formOpacity)
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, AppTheme.Spacing.xl)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Header
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // Gradient header bg
            LinearGradient(
                colors: [AppTheme.Colors.brand, AppTheme.Colors.navy],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 260)
            .ignoresSafeArea(edges: .top)

            VStack(spacing: AppTheme.Spacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                        .fill(.white.opacity(0.15))
                        .frame(width: 72, height: 72)
                    VStack(spacing: 2) {
                        Text("NEU")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("QUEST")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .kerning(3)
                    }
                }

                VStack(spacing: 4) {
                    Text("Welcome Back")
                        .font(AppTheme.Typography.title1())
                        .foregroundColor(.white)
                    Text("Sign in to your NEU account")
                        .font(AppTheme.Typography.subheadline())
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .padding(.bottom, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Form
    private var formSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            VStack(spacing: AppTheme.Spacing.md) {
                // Email field
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("NEU Email")
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.leading, 4)
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .frame(width: 20)
                        TextField("yourname@northeastern.edu", text: $viewModel.email)
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
                            .stroke(viewModel.emailErrorMessage != nil ? AppTheme.Colors.error : AppTheme.Colors.divider, lineWidth: 1)
                    )

                    if let emailError = viewModel.emailErrorMessage {
                        Text(emailError)
                            .font(AppTheme.Typography.caption())
                            .foregroundColor(AppTheme.Colors.error)
                            .padding(.leading, 4)
                    }
                }

                // Password field
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Password")
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .padding(.leading, 4)
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .frame(width: 20)
                        if showPassword {
                            TextField("Password", text: $viewModel.password)
                                .font(AppTheme.Typography.body())
                                .foregroundColor(AppTheme.Colors.textPrimary)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                                .font(AppTheme.Typography.body())
                                .foregroundColor(AppTheme.Colors.textPrimary)
                        }
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(AppTheme.Colors.textTertiary)
                        }
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

            // Login Button
            Button {
                Task { await viewModel.login() }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                    } else {
                        Text("Sign In")
                    }
                }
                .primaryButton()
            }
            .disabled(viewModel.isLoading || !viewModel.isLoginValid)
            .opacity(viewModel.isLoginValid ? 1.0 : 0.6)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoginValid)

            // Divider
            HStack {
                Rectangle().fill(AppTheme.Colors.divider).frame(height: 1)
                Text("or")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.horizontal, 8)
                Rectangle().fill(AppTheme.Colors.divider).frame(height: 1)
            }

            // Sign Up Button
            Button {
                showSignUp = true
            } label: {
                Text("Create NEU Account")
                    .secondaryButton()
            }

            // Hint for demo
            VStack(spacing: 4) {
                Text("Demo credentials")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text("alex.husky@husky.neu.edu  •  any password")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary.opacity(0.7))
                Text("admin@northeastern.edu  •  any password")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary.opacity(0.7))
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surfaceElevated.opacity(0.5))
            .cornerRadius(AppTheme.Radius.md)
            .padding(.top, AppTheme.Spacing.sm)
        }
        .padding(.bottom, AppTheme.Spacing.xxl)
    }
}

#Preview {
    LoginView()
}
