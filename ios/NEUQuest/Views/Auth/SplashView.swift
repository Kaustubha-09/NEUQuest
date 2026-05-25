import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var ringScale: CGFloat = 0.5
    @State private var ringOpacity: Double = 0

    var body: some View {
        ZStack {
            // Background
            AppTheme.Colors.background.ignoresSafeArea()

            // Decorative rings
            Circle()
                .stroke(AppTheme.Colors.brand.opacity(0.15), lineWidth: 1)
                .frame(width: 300, height: 300)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            Circle()
                .stroke(AppTheme.Colors.brand.opacity(0.08), lineWidth: 1)
                .frame(width: 450, height: 450)
                .scaleEffect(ringScale)
                .opacity(ringOpacity)

            VStack(spacing: AppTheme.Spacing.lg) {
                // Logo Mark
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xl)
                        .fill(AppTheme.Colors.brand)
                        .frame(width: 100, height: 100)
                        .shadow(color: AppTheme.Colors.brand.opacity(0.5), radius: 20, x: 0, y: 8)

                    VStack(spacing: 2) {
                        Text("NEU")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        Text("QUEST")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .kerning(4)
                    }
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: AppTheme.Spacing.xs) {
                    Text("NEUQuest")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    Text("Discover. Plan. Experience.")
                        .font(AppTheme.Typography.subheadline())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .kerning(1)
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                ringScale = 1.0
                ringOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
                textOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}
