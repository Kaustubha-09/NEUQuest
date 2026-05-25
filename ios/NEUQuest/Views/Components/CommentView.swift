import SwiftUI

struct CommentView: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
            // Avatar
            Circle()
                .fill(AppTheme.Colors.brand.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Text(String(comment.commenterName.prefix(1)).uppercased())
                        .font(AppTheme.Typography.subheadline())
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.brand)
                )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text(comment.commenterName)
                        .font(AppTheme.Typography.bodyMedium())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                    Spacer()
                    Text(comment.formattedTime)
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                Text(comment.text)
                    .font(AppTheme.Typography.body())
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surfaceElevated)
        .cornerRadius(AppTheme.Radius.md)
    }
}

// MARK: - Comment Input Bar
struct CommentInputBar: View {
    @Binding var text: String
    var onSubmit: () -> Void

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            TextField("Add a comment...", text: $text)
                .font(AppTheme.Typography.body())
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.surfaceElevated)
                .cornerRadius(AppTheme.Radius.full)
                .submitLabel(.send)
                .onSubmit(onSubmit)

            Button(action: onSubmit) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(text.trimmingCharacters(in: .whitespaces).isEmpty
                        ? AppTheme.Colors.textTertiary
                        : AppTheme.Colors.brand)
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
            .animation(.easeInOut(duration: 0.2), value: text)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surface)
    }
}

#Preview {
    VStack(spacing: 12) {
        CommentView(comment: Comment(id: "1", text: "This looks amazing! I can't wait to attend.", timestamp: Date().timeIntervalSince1970 - 3600, commenterName: "Alex T."))
        CommentInputBar(text: .constant("Hello"), onSubmit: {})
    }
    .padding()
    .background(AppTheme.Colors.background)
}
