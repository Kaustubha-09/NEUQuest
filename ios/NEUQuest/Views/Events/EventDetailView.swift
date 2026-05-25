import SwiftUI

struct EventDetailView: View {
    let event: Event
    @StateObject private var viewModel = EventViewModel()
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    @State private var showReportAlert = false
    @State private var isImageExpanded = false
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            AppTheme.Colors.background.ignoresSafeArea()

            // Main scroll content
            ScrollView {
                VStack(spacing: 0) {
                    heroImage
                    contentSection
                }
                .padding(.bottom, 100)
            }
            .ignoresSafeArea(edges: .top)
            .coordinateSpace(name: "scroll")

            // Bottom action bar
            bottomBar
        }
        .navigationBarHidden(true)
        .overlay(alignment: .topLeading) {
            backButton
        }
        .alert("Report Event", isPresented: $showReportAlert) {
            Button("Report", role: .destructive) {
                viewModel.reportEvent(id: event.id)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to report this event as inappropriate?")
        }
    }

    // MARK: - Hero Image
    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: event.imageURL)) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default:
                    Rectangle()
                        .fill(AppTheme.Colors.surfaceElevated)
                        .overlay(
                            Image(systemName: event.categoryEnum?.icon ?? "photo")
                                .font(.system(size: 60))
                                .foregroundColor(AppTheme.Colors.textTertiary)
                        )
                }
            }
            .frame(height: 320)
            .clipped()

            // Gradient overlay
            LinearGradient(
                colors: [.clear, AppTheme.Colors.background],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 160)
            .frame(maxWidth: .infinity, alignment: .bottom)
            .offset(y: 80)

            // Live badge
            if event.isHappeningNow {
                HStack(spacing: 4) {
                    Circle().fill(AppTheme.Colors.success).frame(width: 8, height: 8)
                    Text("LIVE NOW")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.black.opacity(0.6))
                .cornerRadius(AppTheme.Radius.full)
                .padding(AppTheme.Spacing.md)
            }
        }
    }

    // MARK: - Back button
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(.black.opacity(0.45))
                .clipShape(Circle())
        }
        .padding(.top, 56)
        .padding(.leading, AppTheme.Spacing.md)
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            // Title & category
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Text(event.category)
                        .chipStyle(isSelected: true)
                    Spacer()
                    Button {
                        showReportAlert = true
                    } label: {
                        Image(systemName: "flag.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                }

                Text(event.title)
                    .font(AppTheme.Typography.title1())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Info cards row
            HStack(spacing: AppTheme.Spacing.sm) {
                infoChip(icon: "dollarsign.circle.fill", value: event.formattedPrice,
                         color: event.price.lowercased() == "free" ? AppTheme.Colors.success : AppTheme.Colors.gold)
                infoChip(icon: "clock.fill", value: "\(event.startTime) – \(event.endTime)",
                         color: AppTheme.Colors.brand)
            }

            // Date & Location
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                detailRow(icon: "calendar", label: "Date", value: event.formattedDateRange)
                detailRow(icon: "mappin.and.ellipse", label: "Location", value: event.location)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.lg)

            // Description
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("About")
                    .font(AppTheme.Typography.headline())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                Text(event.description)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Comments section
            commentsSection
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.lg)
    }

    // MARK: - Comments section
    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Comments (\(event.comments.count))")
                .font(AppTheme.Typography.headline())
                .foregroundColor(AppTheme.Colors.textPrimary)

            if event.comments.isEmpty {
                Text("Be the first to comment!")
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
            } else {
                ForEach(event.comments.sorted { $0.timestamp > $1.timestamp }) { comment in
                    CommentView(comment: comment)
                }
            }

            // Comment input
            HStack(spacing: AppTheme.Spacing.sm) {
                TextField("Add a comment...", text: $viewModel.newCommentText)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, 10)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.full)
                    .overlay(
                        Capsule().stroke(AppTheme.Colors.divider, lineWidth: 1)
                    )

                Button {
                    viewModel.addComment(
                        to: event.id,
                        commenterName: authService.currentUser?.name ?? "Anonymous"
                    )
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(viewModel.newCommentText.isEmpty
                            ? AppTheme.Colors.textTertiary
                            : AppTheme.Colors.brand)
                }
                .disabled(viewModel.newCommentText.trimmingCharacters(in: .whitespaces).isEmpty)
                .animation(.easeInOut(duration: 0.15), value: viewModel.newCommentText)
            }
        }
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            // Share button
            Button {
                // Share action
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18))
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .frame(width: 52, height: 52)
                    .background(AppTheme.Colors.surface)
                    .cornerRadius(AppTheme.Radius.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                            .stroke(AppTheme.Colors.divider, lineWidth: 1)
                    )
            }

            // Register button
            if !event.registerLink.isEmpty {
                Link(destination: URL(string: event.registerLink) ?? URL(string: "https://northeastern.edu")!) {
                    HStack {
                        Image(systemName: "ticket.fill")
                        Text("Register Now")
                    }
                    .primaryButton()
                }
            } else {
                Button {} label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Free – No Registration")
                    }
                    .primaryButton()
                }
                .disabled(true)
                .opacity(0.7)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(.ultraThinMaterial)
    }

    // MARK: - Helper views
    @ViewBuilder
    private func infoChip(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(AppTheme.Typography.bodyMedium())
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(color.opacity(0.1))
        .cornerRadius(AppTheme.Radius.md)
    }

    @ViewBuilder
    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.brand)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text(value)
                    .font(AppTheme.Typography.bodyMedium())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: Event.mockEvents[0])
            .environmentObject(AuthService.shared)
    }
}
