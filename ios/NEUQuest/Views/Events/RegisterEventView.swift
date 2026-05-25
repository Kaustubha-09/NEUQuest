import SwiftUI

// This view shows a web-like in-app sheet for the registration link.
// It uses a simple redirect notice since WKWebView requires importing WebKit.
struct RegisterEventView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @State private var isRedirecting = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                VStack(spacing: AppTheme.Spacing.xl) {
                    // Event image
                    AsyncImage(url: URL(string: event.imageURL)) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable().scaledToFill()
                        default:
                            Rectangle().fill(AppTheme.Colors.surfaceElevated)
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(AppTheme.Radius.lg)
                    .padding(.horizontal, AppTheme.Spacing.md)

                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Register for Event")
                            .font(AppTheme.Typography.title2())
                            .foregroundColor(AppTheme.Colors.textPrimary)

                        Text(event.title)
                            .font(AppTheme.Typography.headline())
                            .foregroundColor(AppTheme.Colors.brand)
                            .multilineTextAlignment(.center)

                        HStack(spacing: AppTheme.Spacing.sm) {
                            Label(event.location, systemImage: "mappin.circle.fill")
                                .font(AppTheme.Typography.caption())
                                .foregroundColor(AppTheme.Colors.textSecondary)
                            Text("•")
                                .foregroundColor(AppTheme.Colors.textTertiary)
                            Label(event.formattedPrice, systemImage: "ticket.fill")
                                .font(AppTheme.Typography.caption())
                                .foregroundColor(AppTheme.Colors.textSecondary)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)

                    // Registration info card
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        infoRow(icon: "calendar", label: "Date & Time", value: event.formattedDateRange)
                        Divider().background(AppTheme.Colors.divider)
                        infoRow(icon: "link", label: "Registration URL",
                                value: event.registerLink.isEmpty ? "Walk-in welcome" : event.registerLink.truncated(to: 40))
                    }
                    .padding(AppTheme.Spacing.md)
                    .cardStyle()
                    .padding(.horizontal, AppTheme.Spacing.md)

                    Spacer()

                    // Buttons
                    VStack(spacing: AppTheme.Spacing.sm) {
                        if !event.registerLink.isEmpty {
                            Link(destination: URL(string: event.registerLink) ?? URL(string: "https://northeastern.edu")!) {
                                HStack {
                                    Image(systemName: "safari.fill")
                                    Text("Open Registration Page")
                                }
                                .primaryButton()
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }

                        Button {
                            dismiss()
                        } label: {
                            Text("Close")
                                .secondaryButton()
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }
                    .padding(.bottom, AppTheme.Spacing.lg)
                }
            }
            .navigationTitle("Registration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.brand)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textTertiary)
                Text(value)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textPrimary)
            }
            Spacer()
        }
    }
}

#Preview {
    RegisterEventView(event: Event.mockEvents[0])
}
