import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var userService: UserService
    @State private var selectedTrip: Trip?
    @State private var showInterestsEditor = false

    var user: User? { authService.currentUser }

    var plannedTrips: [Trip] {
        guard let user else { return [] }
        return TripService.shared.trips.filter { user.plannedTrips.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        profileHeader
                        infoCard
                        interestsSection
                        tripsSection
                        logoutButton
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.isEditing {
                            Task { await viewModel.saveProfile() }
                        } else {
                            viewModel.startEditing()
                        }
                    } label: {
                        if viewModel.isSaving {
                            ProgressView().progressViewStyle(.circular).tint(AppTheme.Colors.brand)
                        } else {
                            Text(viewModel.isEditing ? "Save" : "Edit")
                                .font(AppTheme.Typography.bodyMedium())
                                .foregroundColor(AppTheme.Colors.brand)
                        }
                    }
                }
                if viewModel.isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { viewModel.cancelEditing() }
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
            .navigationDestination(item: $selectedTrip) { trip in
                TripDetailView(trip: trip)
                    .environmentObject(authService)
                    .environmentObject(UserService.shared)
            }
            .sheet(isPresented: $showInterestsEditor) {
                InterestsView(selectedInterests: $viewModel.editInterests)
            }
        }
        .alert("Sign Out", isPresented: $viewModel.showLogoutAlert) {
            Button("Sign Out", role: .destructive) { viewModel.logout() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.Colors.brand, AppTheme.Colors.navy],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: AppTheme.Colors.brand.opacity(0.4), radius: 12, x: 0, y: 4)

                if let url = user?.profileImageURL, !url.isEmpty {
                    AsyncImage(url: URL(string: url)) { phase in
                        if case .success(let img) = phase {
                            img.resizable().scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 100, height: 100)
                        }
                    }
                } else {
                    Text(user?.initials ?? "?")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if viewModel.isEditing {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(AppTheme.Colors.brand)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }

            // Name
            if viewModel.isEditing {
                TextField("Full Name", text: $viewModel.editName)
                    .font(AppTheme.Typography.title2())
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
            } else {
                Text(user?.name ?? "")
                    .font(AppTheme.Typography.title2())
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }

            Text(user?.email ?? "")
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)

            // Admin badge
            if user?.isAdmin == true {
                HStack(spacing: 4) {
                    Image(systemName: "shield.checkered")
                    Text("Admin")
                }
                .font(AppTheme.Typography.caption())
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(AppTheme.Colors.gold.opacity(0.15))
                .cornerRadius(AppTheme.Radius.full)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.lg)
        .cardStyle()
    }

    // MARK: - Info Card
    private var infoCard: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Details")
                    .font(AppTheme.Typography.headline())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
            }

            if viewModel.isEditing {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Campus")
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                    Picker("Campus", selection: $viewModel.editCampus) {
                        ForEach(NEUCampus.allCases, id: \.rawValue) { campus in
                            Text(campus.rawValue).tag(campus.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(AppTheme.Colors.textPrimary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.Colors.surfaceElevated)
                    .cornerRadius(AppTheme.Radius.md)
                }
            } else {
                profileInfoRow(icon: "building.2.fill", label: "Campus", value: user?.campus ?? "")
                Divider().background(AppTheme.Colors.divider)
                profileInfoRow(icon: "calendar", label: "Events Attended", value: "\(user?.eventsAttended.count ?? 0)")
                Divider().background(AppTheme.Colors.divider)
                profileInfoRow(icon: "map", label: "Trips Planned", value: "\(user?.plannedTrips.count ?? 0)")
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    @ViewBuilder
    private func profileInfoRow(icon: String, label: String, value: String) -> some View {
        HStack {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.brand)
                    .frame(width: 20)
                Text(label)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
            Text(value)
                .font(AppTheme.Typography.bodyMedium())
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
    }

    // MARK: - Interests Section
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Interests")
                    .font(AppTheme.Typography.headline())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Spacer()
                Button {
                    viewModel.startEditing()
                    showInterestsEditor = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil").font(.caption)
                        Text("Edit")
                    }
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.brand)
                }
            }

            let interests = viewModel.isEditing ? viewModel.editInterests : (user?.interests ?? [])
            if interests.isEmpty {
                Text("No interests added yet. Tap Edit to add your interests.")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.surfaceElevated)
                    .cornerRadius(AppTheme.Radius.md)
            } else {
                FlowLayout(spacing: AppTheme.Spacing.xs) {
                    ForEach(interests, id: \.self) { interest in
                        Text(interest)
                            .chipStyle(isSelected: true)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    // MARK: - Trips Section
    private var tripsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Planned Trips")
                .font(AppTheme.Typography.headline())
                .foregroundColor(AppTheme.Colors.textPrimary)

            if plannedTrips.isEmpty {
                Text("No trips planned yet. Use the Trip Planner to create your first adventure!")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(AppTheme.Spacing.md)
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.Colors.surfaceElevated)
                    .cornerRadius(AppTheme.Radius.md)
            } else {
                ForEach(plannedTrips) { trip in
                    Button {
                        selectedTrip = trip
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(trip.title)
                                    .font(AppTheme.Typography.bodyMedium())
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                    .lineLimit(1)
                                Text(trip.formattedDateRange)
                                    .font(AppTheme.Typography.caption())
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(AppTheme.Colors.textTertiary)
                        }
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.Colors.surfaceElevated)
                        .cornerRadius(AppTheme.Radius.md)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    // MARK: - Logout
    private var logoutButton: some View {
        Button {
            viewModel.showLogoutAlert = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Sign Out")
            }
            .font(AppTheme.Typography.bodyMedium())
            .foregroundColor(AppTheme.Colors.error)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(AppTheme.Colors.error.opacity(0.1))
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(AppTheme.Colors.error.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Flow Layout for interests chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthService.shared)
        .environmentObject(UserService.shared)
}
