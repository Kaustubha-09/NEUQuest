import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @StateObject private var tripViewModel = TripViewModel()
    @EnvironmentObject var authService: AuthService
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false
    @State private var selectedEvent: Event?

    var tripEvents: [Event] {
        tripViewModel.events(for: trip)
    }

    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Trip overview card
                    overviewCard

                    // Timeline
                    if tripEvents.isEmpty {
                        noEventsCard
                    } else {
                        timelineSection
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(false)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(AppTheme.Colors.error)
                }
            }
        }
        .alert("Delete Trip", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let user = authService.currentUser {
                    _ = userService.removeTrip(tripID: trip.id, from: user)
                }
                tripViewModel.deleteTrip(id: trip.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete \"\(trip.title)\".")
        }
        .navigationDestination(item: $selectedEvent) { event in
            EventDetailView(event: event)
                .environmentObject(authService)
        }
    }

    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.location)
                        .font(AppTheme.Typography.title2())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Text(trip.formattedDateRange)
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                Spacer()
                Image(systemName: "map.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppTheme.Colors.brand.opacity(0.4))
            }

            Divider().background(AppTheme.Colors.divider)

            // Stats row
            HStack(spacing: 0) {
                statCell(icon: "calendar", value: "\(trip.durationDays)", label: "Days", color: AppTheme.Colors.brand)
                Divider().frame(height: 40).background(AppTheme.Colors.divider)
                statCell(icon: "dollarsign.circle", value: trip.formattedBudgetRange, label: "Budget", color: AppTheme.Colors.gold)
                Divider().frame(height: 40).background(AppTheme.Colors.divider)
                statCell(icon: "calendar.badge.checkmark", value: "\(trip.eventIDs.count)", label: "Events", color: AppTheme.Colors.success)
            }

            Divider().background(AppTheme.Colors.divider)

            // Inclusions
            HStack(spacing: AppTheme.Spacing.sm) {
                inclusionChip(icon: "fork.knife", label: "Meals", included: trip.isMealsIncluded)
                inclusionChip(icon: "bus.fill", label: "Transport", included: trip.isTransportIncluded)
                Spacer()
            }
        }
        .padding(AppTheme.Spacing.md)
        .cardStyle()
    }

    @ViewBuilder
    private func statCell(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 18))
            Text(value)
                .font(AppTheme.Typography.bodyMedium())
                .foregroundColor(AppTheme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(AppTheme.Typography.caption2())
                .foregroundColor(AppTheme.Colors.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.sm)
    }

    @ViewBuilder
    private func inclusionChip(icon: String, label: String, included: Bool) -> some View {
        HStack(spacing: 4) {
            Image(systemName: included ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(included ? AppTheme.Colors.success : AppTheme.Colors.textTertiary)
            Text(label)
                .font(AppTheme.Typography.caption())
                .foregroundColor(included ? AppTheme.Colors.textSecondary : AppTheme.Colors.textTertiary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(included ? AppTheme.Colors.success.opacity(0.1) : AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.full)
        .overlay(
            Capsule().stroke(included ? AppTheme.Colors.success.opacity(0.3) : AppTheme.Colors.divider, lineWidth: 1)
        )
    }

    // MARK: - Timeline Section
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Trip Timeline")
                .font(AppTheme.Typography.headline())
                .foregroundColor(AppTheme.Colors.textPrimary)

            VStack(spacing: 0) {
                ForEach(Array(tripEvents.enumerated()), id: \.element.id) { index, event in
                    timelineRow(event: event, index: index, isLast: index == tripEvents.count - 1)
                }
            }
        }
    }

    @ViewBuilder
    private func timelineRow(event: Event, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            // Timeline connector
            VStack(spacing: 0) {
                Circle()
                    .fill(AppTheme.Colors.brand)
                    .frame(width: 12, height: 12)
                    .padding(.top, 16)
                if !isLast {
                    Rectangle()
                        .fill(AppTheme.Colors.brand.opacity(0.3))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 20)

            // Event card
            Button {
                selectedEvent = event
            } label: {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.title)
                                .font(AppTheme.Typography.bodyMedium())
                                .foregroundColor(AppTheme.Colors.textPrimary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            HStack(spacing: 4) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppTheme.Colors.textTertiary)
                                Text("\(event.startDate) · \(event.startTime)")
                                    .font(AppTheme.Typography.caption())
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(event.category)
                                .font(AppTheme.Typography.caption2())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppTheme.Colors.brand.opacity(0.15))
                                .foregroundColor(AppTheme.Colors.brand)
                                .cornerRadius(4)
                            Text(event.formattedPrice)
                                .font(AppTheme.Typography.caption())
                                .foregroundColor(AppTheme.Colors.gold)
                        }
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.Colors.brand)
                        Text(event.location)
                            .font(AppTheme.Typography.caption())
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                .padding(AppTheme.Spacing.md)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                        .stroke(AppTheme.Colors.divider, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, isLast ? 0 : AppTheme.Spacing.sm)
    }

    // MARK: - No events card
    private var noEventsCard: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "calendar.badge.questionmark")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.Colors.textTertiary)
            Text("No events in this date range")
                .font(AppTheme.Typography.title3())
                .foregroundColor(AppTheme.Colors.textPrimary)
            Text("Events from \(trip.startDate) to \(trip.endDate) will appear here automatically.")
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(AppTheme.Spacing.xl)
        .cardStyle()
    }
}

#Preview {
    NavigationStack {
        TripDetailView(trip: Trip.mockTrips[0])
            .environmentObject(AuthService.shared)
            .environmentObject(UserService.shared)
    }
}
