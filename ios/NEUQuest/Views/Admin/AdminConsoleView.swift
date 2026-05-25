import SwiftUI

struct AdminConsoleView: View {
    @StateObject private var viewModel = AdminViewModel()
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var eventService: EventService
    @State private var selectedTab: AdminTab = .reported
    @State private var showAddEvent = false

    enum AdminTab: String, CaseIterable {
        case reported = "Reported"
        case addEvent = "Add Event"

        var icon: String {
            switch self {
            case .reported: return "flag.fill"
            case .addEvent: return "plus.circle.fill"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerView

                    // Tab switcher
                    tabSwitcher
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.md)

                    // Content
                    if selectedTab == .reported {
                        reportedEventsTab
                    } else {
                        AddEventView(viewModel: viewModel)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onReceive(eventService.$events) { _ in }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "shield.checkered")
                        .foregroundColor(AppTheme.Colors.gold)
                    Text("Admin Console")
                        .font(AppTheme.Typography.title1())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
                Text("Manage events & reports")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
            // Reported count badge
            if !viewModel.reportedEvents.isEmpty {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "flag.fill")
                        .font(.system(size: 20))
                        .foregroundColor(AppTheme.Colors.error)
                    Circle()
                        .fill(AppTheme.Colors.error)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text("\(viewModel.reportedEvents.count)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 8, y: -8)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.md)
    }

    // MARK: - Tab Switcher
    private var tabSwitcher: some View {
        HStack(spacing: 0) {
            ForEach(AdminTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = tab
                    }
                } label: {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 14))
                        Text(tab.rawValue)
                            .font(AppTheme.Typography.bodyMedium())
                        if tab == .reported && !viewModel.reportedEvents.isEmpty {
                            Text("\(viewModel.reportedEvents.count)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(AppTheme.Colors.error)
                                .clipShape(Circle())
                        }
                    }
                    .foregroundColor(selectedTab == tab ? AppTheme.Colors.brand : AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(
                        Group {
                            if selectedTab == tab {
                                RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                                    .fill(AppTheme.Colors.brand.opacity(0.15))
                            }
                        }
                    )
                }
            }
        }
        .padding(4)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Reported Events Tab
    private var reportedEventsTab: some View {
        Group {
            if viewModel.reportedEvents.isEmpty {
                emptyReportsView
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.md) {
                        ForEach(viewModel.reportedEvents) { event in
                            reportedEventCard(event: event)
                                .padding(.horizontal, AppTheme.Spacing.md)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }

    @ViewBuilder
    private func reportedEventCard(event: Event) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Event info
            HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                // Image thumbnail
                AsyncImage(url: URL(string: event.imageURL)) { phase in
                    if case .success(let img) = phase {
                        img.resizable().scaledToFill()
                    } else {
                        Rectangle().fill(AppTheme.Colors.surfaceElevated)
                            .overlay(Image(systemName: "photo").foregroundColor(AppTheme.Colors.textTertiary))
                    }
                }
                .frame(width: 64, height: 64)
                .clipped()
                .cornerRadius(AppTheme.Radius.sm)

                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(AppTheme.Typography.bodyMedium())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .lineLimit(2)
                    Text(event.location)
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    HStack(spacing: 4) {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 10))
                        Text("Reported by user")
                    }
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.error)
                }
                Spacer()
            }

            Divider().background(AppTheme.Colors.divider)

            // Action buttons
            HStack(spacing: AppTheme.Spacing.sm) {
                Button {
                    withAnimation {
                        viewModel.approveEvent(id: event.id)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Approve")
                    }
                    .font(AppTheme.Typography.caption())
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.success)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.success.opacity(0.15))
                    .cornerRadius(AppTheme.Radius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                            .stroke(AppTheme.Colors.success.opacity(0.3), lineWidth: 1)
                    )
                }

                Button {
                    withAnimation {
                        viewModel.removeEvent(id: event.id)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "trash.fill")
                        Text("Remove")
                    }
                    .font(AppTheme.Typography.caption())
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.error)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.error.opacity(0.15))
                    .cornerRadius(AppTheme.Radius.sm)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                            .stroke(AppTheme.Colors.error.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    // MARK: - Empty Reports
    private var emptyReportsView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 64))
                .foregroundColor(AppTheme.Colors.success.opacity(0.4))
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("All Clear!")
                    .font(AppTheme.Typography.title2())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("No events have been reported. The community is behaving well.")
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }
            Spacer()
        }
    }
}

#Preview {
    AdminConsoleView()
        .environmentObject(AuthService.shared)
        .environmentObject(EventService.shared)
}
