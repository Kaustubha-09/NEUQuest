import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authService: AuthService
    @State private var selectedTab: Tab = .rightNow

    enum Tab: Int, CaseIterable {
        case rightNow = 0
        case trips = 1
        case profile = 2
        case admin = 3

        var title: String {
            switch self {
            case .rightNow: return "RightNow"
            case .trips: return "Trips"
            case .profile: return "Profile"
            case .admin: return "Admin"
            }
        }

        var icon: String {
            switch self {
            case .rightNow: return "bolt.fill"
            case .trips: return "map.fill"
            case .profile: return "person.fill"
            case .admin: return "shield.checkered"
            }
        }
    }

    var isAdmin: Bool { authService.currentUser?.isAdmin == true }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case .rightNow:
                    RightNowView()
                        .environmentObject(EventService.shared)
                case .trips:
                    TripPlannerView()
                        .environmentObject(authService)
                        .environmentObject(UserService.shared)
                case .profile:
                    ProfileView()
                        .environmentObject(authService)
                        .environmentObject(UserService.shared)
                case .admin:
                    if isAdmin {
                        AdminConsoleView()
                            .environmentObject(authService)
                            .environmentObject(EventService.shared)
                    } else {
                        Text("Access Denied")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom tab bar
            customTabBar
        }
        .background(AppTheme.Colors.background.ignoresSafeArea())
    }

    // MARK: - Custom Tab Bar
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(visibleTabs, id: \.rawValue) { tab in
                tabBarItem(tab: tab)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.md)
        .background(
            AppTheme.Colors.surface
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AppTheme.Colors.divider),
                    alignment: .top
                )
        )
    }

    private var visibleTabs: [Tab] {
        isAdmin ? Tab.allCases : Tab.allCases.filter { $0 != .admin }
    }

    @ViewBuilder
    private func tabBarItem(tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: selectedTab == tab ? 22 : 20))
                    .foregroundColor(selectedTab == tab ? AppTheme.Colors.brand : AppTheme.Colors.textTertiary)
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)

                Text(tab.title)
                    .font(.system(size: 10, weight: selectedTab == tab ? .semibold : .regular, design: .rounded))
                    .foregroundColor(selectedTab == tab ? AppTheme.Colors.brand : AppTheme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(
                Group {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                            .fill(AppTheme.Colors.brand.opacity(0.1))
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3), value: selectedTab)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthService.shared)
}
