import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var authService: AuthService
    @State private var pulsate: Bool = false
    @State private var showDoneConfirm: Bool = false

    var email: String { authService.currentUser?.email ?? "your NEU email" }

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.xl) {
                Spacer()

                // Animated envelope icon
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.brand.opacity(0.1))
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulsate ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true), value: pulsate)

                    Image(systemName: "envelope.open.fill")
                        .font(.system(size: 60))
                        .foregroundColor(AppTheme.Colors.brand)
                }
                .onAppear { pulsate = true }

                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Verify Your Email")
                        .font(AppTheme.Typography.title1())
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Text("We've sent a verification link to:")
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textSecondary)

                    Text(email)
                        .font(AppTheme.Typography.bodyMedium())
                        .foregroundColor(AppTheme.Colors.gold)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.gold.opacity(0.1))
                        .cornerRadius(AppTheme.Radius.sm)

                    Text("Please check your inbox and click the link to activate your account before exploring events.")
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.xs)
                }

                // Steps
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    verificationStep(number: "1", text: "Open your @northeastern.edu or @husky.neu.edu inbox")
                    verificationStep(number: "2", text: "Click the verification link in our email")
                    verificationStep(number: "3", text: "Return here and tap \"I've Verified\"")
                }
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.lg)
                .padding(.horizontal, AppTheme.Spacing.lg)

                Spacer()

                VStack(spacing: AppTheme.Spacing.sm) {
                    // Already verified button
                    Button {
                        showDoneConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                            Text("I've Verified My Email")
                        }
                        .primaryButton()
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)

                    // Logout / back
                    Button {
                        authService.logout()
                    } label: {
                        Text("Use a Different Account")
                            .font(AppTheme.Typography.subheadline())
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .padding(.bottom, AppTheme.Spacing.lg)
                }
            }
        }
        .confirmationDialog("Did you verify your email?", isPresented: $showDoneConfirm, titleVisibility: .visible) {
            Button("Yes, Continue to App") {
                authService.markEmailVerified()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Make sure you've clicked the link in the email before continuing.")
        }
    }

    @ViewBuilder
    private func verificationStep(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Circle()
                .fill(AppTheme.Colors.brand)
                .frame(width: 24, height: 24)
                .overlay(
                    Text(number)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                )
            Text(text)
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    EmailVerificationView()
        .environmentObject(AuthService.shared)
}
