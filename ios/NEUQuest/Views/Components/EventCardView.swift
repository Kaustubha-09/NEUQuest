import SwiftUI

struct EventCardView: View {
    let event: Event
    var isCompact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: event.imageURL)) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .failure:
                        placeholderImage
                    case .empty:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(height: isCompact ? 120 : 180)
                .clipped()

                // Live / Category badge
                HStack(spacing: AppTheme.Spacing.xs) {
                    if event.isHappeningNow {
                        liveBadge
                    }
                    categoryBadge
                }
                .padding(AppTheme.Spacing.sm)
            }

            // Content
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(event.title)
                    .font(AppTheme.Typography.headline())
                    .foregroundColor(AppTheme.Colors.textPrimary)
                    .lineLimit(isCompact ? 1 : 2)

                HStack(spacing: AppTheme.Spacing.xs) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(AppTheme.Colors.brand)
                        .font(.caption)
                    Text(event.location)
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .lineLimit(1)
                    Spacer()
                    priceTag
                }

                if !isCompact {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: "calendar")
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .font(.caption)
                        Text("\(event.startDate) at \(event.startTime)")
                            .font(AppTheme.Typography.caption())
                            .foregroundColor(AppTheme.Colors.textTertiary)
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .cardStyle()
    }

    // MARK: - Sub-views
    private var placeholderImage: some View {
        Rectangle()
            .fill(AppTheme.Colors.surfaceElevated)
            .overlay(
                Image(systemName: event.categoryEnum?.icon ?? "photo")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.Colors.textTertiary)
            )
    }

    private var liveBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(AppTheme.Colors.success)
                .frame(width: 6, height: 6)
            Text("LIVE")
                .font(AppTheme.Typography.caption2())
                .fontWeight(.bold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.black.opacity(0.6))
        .cornerRadius(AppTheme.Radius.full)
    }

    private var categoryBadge: some View {
        Text(event.category)
            .font(AppTheme.Typography.caption2())
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(AppTheme.Colors.brand.opacity(0.85))
            .foregroundColor(.white)
            .cornerRadius(AppTheme.Radius.full)
    }

    private var priceTag: some View {
        Text(event.formattedPrice)
            .font(AppTheme.Typography.caption())
            .fontWeight(.semibold)
            .foregroundColor(event.price.lowercased() == "free" ? AppTheme.Colors.success : AppTheme.Colors.gold)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            EventCardView(event: Event.mockEvents[0])
            EventCardView(event: Event.mockEvents[1], isCompact: true)
        }
        .padding()
    }
    .background(AppTheme.Colors.background)
}
