import SwiftUI

struct RootView: View {
    @EnvironmentObject var authService: AuthService
    @State private var showSplash: Bool = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                authStateView
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show splash for 1.8 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showSplash = false
                }
            }
        }
    }

    @ViewBuilder
    private var authStateView: some View {
        if authService.isAuthenticated, let user = authService.currentUser {
            if !user.isEmailVerified {
                EmailVerificationView()
                    .environmentObject(authService)
            } else {
                MainTabView()
                    .environmentObject(authService)
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AuthService.shared)
}
