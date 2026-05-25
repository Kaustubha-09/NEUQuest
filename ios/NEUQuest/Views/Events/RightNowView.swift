import SwiftUI

struct RightNowView: View {
    @StateObject private var viewModel = EventViewModel()
    @EnvironmentObject var eventService: EventService
    @State private var showSearch = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.top, AppTheme.Spacing.sm)
                        .padding(.bottom, AppTheme.Spacing.md)

                    // Search bar (animated)
                    if showSearch {
                        searchBar
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.bottom, AppTheme.Spacing.sm)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Category chips
                    CategoryChipRow(selectedCategory: $viewModel.selectedCategory)
                        .padding(.bottom, AppTheme.Spacing.sm)

                    // Events list
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.displayedEvents.isEmpty {
                        emptyStateView
                    } else {
                        eventsList
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .task { await viewModel.fetchEvents() }
        .onReceive(eventService.$events) { _ in }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("RightNow")
                    .font(AppTheme.Typography.title1())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("Events happening around you")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
            Button {
                withAnimation(.spring(response: 0.35)) {
                    showSearch.toggle()
                }
                if !showSearch {
                    viewModel.searchText = ""
                }
            } label: {
                Image(systemName: showSearch ? "xmark.circle.fill" : "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(showSearch ? AppTheme.Colors.textSecondary : AppTheme.Colors.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.Colors.surface)
                    .clipShape(Circle())
            }
        }
    }

    // MARK: - Search bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.textTertiary)
            TextField("Search events, locations...", text: $viewModel.searchText)
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.Colors.textPrimary)
                .autocorrectionDisabled()
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
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

    // MARK: - Events List
    private var eventsList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                // "Live Now" section if any
                let liveEvents = viewModel.displayedEvents.filter { $0.isHappeningNow }
                let upcomingEvents = viewModel.displayedEvents.filter { !$0.isHappeningNow }

                if !liveEvents.isEmpty {
                    sectionHeader("Live Now", icon: "circle.fill", iconColor: AppTheme.Colors.success)
                    ForEach(liveEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventCardView(event: event)
                                .padding(.horizontal, AppTheme.Spacing.md)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !upcomingEvents.isEmpty {
                    sectionHeader("Upcoming Events", icon: "calendar", iconColor: AppTheme.Colors.brand)
                    ForEach(upcomingEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventCardView(event: event)
                                .padding(.horizontal, AppTheme.Spacing.md)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.bottom, 100)
        }
        .refreshable { await viewModel.fetchEvents() }
    }

    @ViewBuilder
    private func sectionHeader(_ title: String, icon: String, iconColor: Color) -> some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(iconColor)
            Text(title)
                .font(AppTheme.Typography.headline())
                .foregroundColor(AppTheme.Colors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
    }

    // MARK: - Loading
    private var loadingView: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                        .fill(AppTheme.Colors.surface)
                        .frame(height: 240)
                        .shimmer()
                        .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
            .padding(.top, AppTheme.Spacing.sm)
        }
    }

    // MARK: - Empty state
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.Colors.textTertiary)
            Text("No events found")
                .font(AppTheme.Typography.title3())
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text(viewModel.selectedCategory != nil
                 ? "No \(viewModel.selectedCategory!.rawValue) events available right now"
                 : "Check back soon for new events!")
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
            if viewModel.selectedCategory != nil {
                Button {
                    viewModel.selectedCategory = nil
                } label: {
                    Text("Show All Events")
                        .secondaryButton(fullWidth: false)
                }
            }
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
    }
}

#Preview {
    RightNowView()
        .environmentObject(EventService.shared)
}
