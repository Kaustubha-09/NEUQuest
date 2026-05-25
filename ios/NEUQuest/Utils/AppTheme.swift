import SwiftUI

// MARK: - AppTheme
enum AppTheme {
    // MARK: Colors
    enum Colors {
        static let brand = Color(hex: "#CC0000")       // NEU Red
        static let navy = Color(hex: "#0A1628")        // Dark Navy
        static let gold = Color(hex: "#FFD700")        // Gold
        static let background = Color(hex: "#0A1628")
        static let surface = Color(hex: "#112040")
        static let surfaceElevated = Color(hex: "#1A3060")
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.7)
        static let textTertiary = Color.white.opacity(0.4)
        static let divider = Color.white.opacity(0.1)
        static let success = Color(hex: "#4CAF50")
        static let error = Color(hex: "#FF4444")
        static let warning = Color(hex: "#FF9800")
    }

    // MARK: Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: Radius
    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: Typography
    enum Typography {
        static func largeTitle() -> Font { .system(.largeTitle, design: .rounded, weight: .bold) }
        static func title1() -> Font { .system(.title, design: .rounded, weight: .bold) }
        static func title2() -> Font { .system(.title2, design: .rounded, weight: .semibold) }
        static func title3() -> Font { .system(.title3, design: .rounded, weight: .semibold) }
        static func headline() -> Font { .system(.headline, design: .rounded, weight: .semibold) }
        static func body() -> Font { .system(.body, design: .rounded) }
        static func bodyMedium() -> Font { .system(.body, design: .rounded, weight: .medium) }
        static func subheadline() -> Font { .system(.subheadline, design: .rounded) }
        static func caption() -> Font { .system(.caption, design: .rounded) }
        static func caption2() -> Font { .system(.caption2, design: .rounded) }
    }
}

// MARK: - View Modifiers
struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                    .stroke(AppTheme.Colors.divider, lineWidth: 1)
            )
    }
}

struct PrimaryButtonModifier: ViewModifier {
    var isFullWidth: Bool
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.headline())
            .foregroundColor(.white)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 52)
            .padding(.horizontal, isFullWidth ? 0 : AppTheme.Spacing.xl)
            .background(AppTheme.Colors.brand)
            .cornerRadius(AppTheme.Radius.md)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    var isFullWidth: Bool
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.headline())
            .foregroundColor(AppTheme.Colors.brand)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 52)
            .padding(.horizontal, isFullWidth ? 0 : AppTheme.Spacing.xl)
            .background(AppTheme.Colors.brand.opacity(0.15))
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(AppTheme.Colors.brand, lineWidth: 1.5)
            )
    }
}

struct ChipStyleModifier: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .font(AppTheme.Typography.caption())
            .foregroundColor(isSelected ? .white : AppTheme.Colors.textSecondary)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(isSelected ? AppTheme.Colors.brand : AppTheme.Colors.surfaceElevated)
            .cornerRadius(AppTheme.Radius.full)
            .overlay(
                Capsule()
                    .stroke(isSelected ? AppTheme.Colors.brand : AppTheme.Colors.divider, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyleModifier()) }
    func primaryButton(fullWidth: Bool = true) -> some View { modifier(PrimaryButtonModifier(isFullWidth: fullWidth)) }
    func secondaryButton(fullWidth: Bool = true) -> some View { modifier(SecondaryButtonModifier(isFullWidth: fullWidth)) }
    func chipStyle(isSelected: Bool = false) -> some View { modifier(ChipStyleModifier(isSelected: isSelected)) }
}
