import SwiftUI

struct InterestsView: View {
    @Binding var selectedInterests: [String]
    @Environment(\.dismiss) private var dismiss

    var allInterests: [String] { UserService.allInterests }

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                        // Subtitle
                        Text("Select your interests to get personalized event recommendations.")
                            .font(AppTheme.Typography.body())
                            .foregroundColor(AppTheme.Colors.textSecondary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.top, AppTheme.Spacing.sm)

                        // Selected count
                        if !selectedInterests.isEmpty {
                            HStack {
                                Text("\(selectedInterests.count) interest\(selectedInterests.count == 1 ? "" : "s") selected")
                                    .font(AppTheme.Typography.caption())
                                    .foregroundColor(AppTheme.Colors.brand)
                                Spacer()
                                Button {
                                    selectedInterests.removeAll()
                                } label: {
                                    Text("Clear all")
                                        .font(AppTheme.Typography.caption())
                                        .foregroundColor(AppTheme.Colors.textTertiary)
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }

                        // Interest grid
                        FlowLayout(spacing: AppTheme.Spacing.sm) {
                            ForEach(allInterests, id: \.self) { interest in
                                Button {
                                    withAnimation(.spring(response: 0.25)) {
                                        if selectedInterests.contains(interest) {
                                            selectedInterests.removeAll { $0 == interest }
                                        } else {
                                            selectedInterests.append(interest)
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        if selectedInterests.contains(interest) {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 10, weight: .bold))
                                        }
                                        Text(interest)
                                    }
                                    .chipStyle(isSelected: selectedInterests.contains(interest))
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("My Interests")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppTheme.Typography.bodyMedium())
                    .foregroundColor(AppTheme.Colors.brand)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }
        }
    }
}

#Preview {
    InterestsView(selectedInterests: .constant(["Art", "Music", "Food"]))
}
