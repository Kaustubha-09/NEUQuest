import SwiftUI

struct CategoryChipRow: View {
    @Binding var selectedCategory: EventCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                // "All" chip
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedCategory = nil
                    }
                } label: {
                    Text("All")
                        .chipStyle(isSelected: selectedCategory == nil)
                }

                ForEach(EventCategory.allCases, id: \.self) { category in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 11))
                            Text(category.rawValue)
                        }
                        .chipStyle(isSelected: selectedCategory == category)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.xs)
        }
    }
}

#Preview {
    VStack {
        CategoryChipRow(selectedCategory: .constant(nil))
        CategoryChipRow(selectedCategory: .constant(.art))
    }
    .background(AppTheme.Colors.background)
}
