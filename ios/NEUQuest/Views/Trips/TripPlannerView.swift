import SwiftUI

struct TripPlannerView: View {
    @StateObject private var viewModel = TripViewModel()
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var userService: UserService
    @State private var showNewTripSheet = false
    @State private var selectedTrip: Trip?

    var userTrips: [Trip] {
        guard let user = authService.currentUser else { return [] }
        return viewModel.userTrips(plannedIDs: user.plannedTrips)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    headerView

                    if userTrips.isEmpty {
                        emptyStateView
                    } else {
                        tripsList
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showNewTripSheet) {
                NewTripSheet(viewModel: viewModel, onCreated: { trip in
                    if let user = authService.currentUser {
                        let updated = userService.addTrip(tripID: trip.id, to: user)
                        _ = updated
                    }
                })
                .environmentObject(authService)
            }
            .navigationDestination(item: $selectedTrip) { trip in
                TripDetailView(trip: trip)
                    .environmentObject(authService)
                    .environmentObject(UserService.shared)
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Trip Planner")
                    .font(AppTheme.Typography.title1())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("Plan your NEU adventures")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
            Button {
                showNewTripSheet = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.Colors.brand)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.md)
    }

    // MARK: - Trips List
    private var tripsList: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.md) {
                ForEach(userTrips) { trip in
                    TripCardView(trip: trip, eventsCount: trip.eventIDs.count)
                        .onTapGesture { selectedTrip = trip }
                        .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
            .padding(.bottom, 100)
        }
        .refreshable {}
    }

    // MARK: - Empty state
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Spacer()
            Image(systemName: "map.fill")
                .font(.system(size: 64))
                .foregroundColor(AppTheme.Colors.brand.opacity(0.3))
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("No trips yet")
                    .font(AppTheme.Typography.title3())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text("Create your first NEU adventure trip and automatically discover matching events.")
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }
            Button {
                showNewTripSheet = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Plan My First Trip")
                }
                .secondaryButton(fullWidth: false)
            }
            Spacer()
        }
    }
}

// MARK: - Trip Card
struct TripCardView: View {
    let trip: Trip
    let eventsCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Top row
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(trip.title)
                        .font(AppTheme.Typography.title3())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .lineLimit(2)

                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(AppTheme.Colors.brand)
                            .font(.caption)
                        Text(trip.location)
                            .font(AppTheme.Typography.caption())
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
                Spacer()
                // Duration badge
                VStack {
                    Text("\(trip.durationDays)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(AppTheme.Colors.brand)
                    Text("days")
                        .font(AppTheme.Typography.caption2())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                .frame(width: 56, height: 56)
                .background(AppTheme.Colors.brand.opacity(0.1))
                .cornerRadius(AppTheme.Radius.md)
            }

            Divider().background(AppTheme.Colors.divider)

            // Info row
            HStack(spacing: AppTheme.Spacing.lg) {
                infoItem(icon: "calendar", value: trip.formattedDateRange)
                infoItem(icon: "dollarsign.circle", value: trip.formattedBudgetRange)
            }

            // Tags row
            HStack(spacing: AppTheme.Spacing.xs) {
                if trip.isMealsIncluded {
                    tagChip(icon: "fork.knife", label: "Meals", color: AppTheme.Colors.success)
                }
                if trip.isTransportIncluded {
                    tagChip(icon: "bus.fill", label: "Transport", color: AppTheme.Colors.brand)
                }
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "calendar.badge.checkmark")
                        .font(.system(size: 12))
                    Text("\(eventsCount) event\(eventsCount == 1 ? "" : "s")")
                        .font(AppTheme.Typography.caption())
                }
                .foregroundColor(AppTheme.Colors.gold)
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    @ViewBuilder
    private func infoItem(icon: String, value: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.Colors.textTertiary)
            Text(value)
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private func tagChip(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10))
            Text(label).font(AppTheme.Typography.caption())
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.12))
        .cornerRadius(AppTheme.Radius.full)
    }
}

// MARK: - New Trip Sheet
struct NewTripSheet: View {
    @ObservedObject var viewModel: TripViewModel
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    var onCreated: (Trip) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Title field with AI generation
                        titleSection

                        // Location
                        fieldSection(title: "Location", icon: "mappin.circle.fill") {
                            TextField("e.g. Boston, Cape Cod", text: $viewModel.tripLocation)
                                .textFieldStyle(NEUTextFieldStyle())
                        }

                        // Date range
                        dateSection

                        // Budget
                        budgetSection

                        // Toggles
                        toggleSection

                        // Matched events preview
                        if !viewModel.matchedEvents.isEmpty {
                            matchedEventsSection
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
            .navigationTitle("Plan New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        if let trip = viewModel.createTrip(for: authService.currentUser?.id ?? "") {
                            onCreated(trip)
                            dismiss()
                        }
                    }
                    .font(AppTheme.Typography.headline())
                    .foregroundColor(viewModel.isFormValid ? AppTheme.Colors.brand : AppTheme.Colors.textTertiary)
                    .disabled(!viewModel.isFormValid)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.startDate) { viewModel.matchEvents() }
        .onChange(of: viewModel.endDate) { viewModel.matchEvents() }
    }

    // MARK: - Title section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Trip Name")
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.leading, 4)

            HStack(spacing: AppTheme.Spacing.sm) {
                TextField("Name your trip", text: $viewModel.tripTitle)
                    .textFieldStyle(NEUTextFieldStyle())

                Button {
                    Task {
                        await viewModel.generateTitle(interests: authService.currentUser?.interests ?? [])
                    }
                } label: {
                    if viewModel.isGeneratingTitle {
                        ProgressView().progressViewStyle(.circular).tint(.white)
                            .frame(width: 44, height: 44)
                    } else {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .background(AppTheme.Colors.brand)
                .cornerRadius(AppTheme.Radius.md)
                .disabled(viewModel.isGeneratingTitle || viewModel.tripLocation.isEmpty)
            }

            if viewModel.tripLocation.isEmpty {
                Text("Enter a location first to generate an AI trip name")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.leading, 4)
            }
        }
    }

    // MARK: - Date section
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Travel Dates")
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.leading, 4)

            HStack(spacing: AppTheme.Spacing.sm) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Start").font(AppTheme.Typography.caption2()).foregroundColor(AppTheme.Colors.textTertiary)
                    DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)

                Image(systemName: "arrow.right")
                    .foregroundColor(AppTheme.Colors.textTertiary)

                VStack(alignment: .leading, spacing: 4) {
                    Text("End").font(AppTheme.Typography.caption2()).foregroundColor(AppTheme.Colors.textTertiary)
                    DatePicker("", selection: $viewModel.endDate, in: viewModel.startDate..., displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppTheme.Spacing.sm)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
            }
        }
    }

    // MARK: - Budget section
    private var budgetSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Budget Range")
                .font(AppTheme.Typography.caption())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .padding(.leading, 4)

            BudgetRangeSlider(minValue: $viewModel.minBudget, maxValue: $viewModel.maxBudget)
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
        }
    }

    // MARK: - Toggle section
    private var toggleSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            toggleRow(
                icon: "fork.knife",
                title: "Meals Included",
                subtitle: "Include food & dining in your trip",
                isOn: $viewModel.mealsIncluded,
                color: AppTheme.Colors.success
            )
            toggleRow(
                icon: "bus.fill",
                title: "Transport Included",
                subtitle: "Include transportation costs",
                isOn: $viewModel.transportIncluded,
                color: AppTheme.Colors.brand
            )
        }
    }

    @ViewBuilder
    private func toggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>, color: Color) -> some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.15))
                .cornerRadius(AppTheme.Radius.sm)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.Typography.bodyMedium())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(subtitle)
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .tint(AppTheme.Colors.brand)
                .labelsHidden()
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.md)
    }

    // MARK: - Matched events
    private var matchedEventsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(AppTheme.Colors.success)
                Text("\(viewModel.matchedEvents.count) events found in this date range")
                    .font(AppTheme.Typography.bodyMedium())
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.success.opacity(0.1))
            .cornerRadius(AppTheme.Radius.md)

            ForEach(viewModel.matchedEvents.prefix(3)) { event in
                HStack(spacing: AppTheme.Spacing.sm) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppTheme.Colors.brand)
                        .frame(width: 4, height: 40)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.title).font(AppTheme.Typography.bodyMedium()).foregroundColor(AppTheme.Colors.textPrimary).lineLimit(1)
                        Text("\(event.startDate) at \(event.startTime)").font(AppTheme.Typography.caption()).foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    Spacer()
                    Text(event.formattedPrice)
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.gold)
                }
            }
            if viewModel.matchedEvents.count > 3 {
                Text("+ \(viewModel.matchedEvents.count - 3) more events")
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .padding(.leading, AppTheme.Spacing.sm)
            }
        }
    }

    @ViewBuilder
    private func fieldSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(spacing: 4) {
                Image(systemName: icon).foregroundColor(AppTheme.Colors.brand).font(.caption)
                Text(title).font(AppTheme.Typography.caption()).foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.leading, 4)
            content()
        }
    }
}

// MARK: - Custom TextField Style
struct NEUTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(AppTheme.Typography.body())
            .foregroundColor(AppTheme.Colors.textPrimary)
            .padding()
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(AppTheme.Colors.divider, lineWidth: 1)
            )
    }
}

#Preview {
    TripPlannerView()
        .environmentObject(AuthService.shared)
        .environmentObject(UserService.shared)
}
