import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: AdminViewModel
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                // Form fields
                formSection
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, 120)
        }
        .overlay(alignment: .bottom) {
            submitButton
        }
        .overlay(alignment: .top) {
            if viewModel.showSuccessToast {
                successToast
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { viewModel.showSuccessToast = false }
                        }
                    }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Title
            fieldView(label: "Event Title *", icon: "text.cursor") {
                TextField("e.g. NEU Arts Festival 2026", text: $viewModel.title)
                    .textFieldStyle(NEUTextFieldStyle())
            }

            // Category
            fieldView(label: "Category *", icon: "tag.fill") {
                Picker("Category", selection: $viewModel.category) {
                    ForEach(EventCategory.allCases, id: \.rawValue) { cat in
                        HStack {
                            Image(systemName: cat.icon)
                            Text(cat.rawValue)
                        }.tag(cat.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .tint(AppTheme.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
                .overlay(RoundedRectangle(cornerRadius: AppTheme.Radius.md).stroke(AppTheme.Colors.divider, lineWidth: 1))
            }

            // Description
            fieldView(label: "Description *", icon: "text.alignleft") {
                ZStack(alignment: .topLeading) {
                    if viewModel.description.isEmpty {
                        Text("Describe your event in detail...")
                            .font(AppTheme.Typography.body())
                            .foregroundColor(AppTheme.Colors.textTertiary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                    }
                    TextEditor(text: $viewModel.description)
                        .font(AppTheme.Typography.body())
                        .foregroundColor(AppTheme.Colors.textPrimary)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 100)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                }
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.Radius.md)
                .overlay(RoundedRectangle(cornerRadius: AppTheme.Radius.md).stroke(AppTheme.Colors.divider, lineWidth: 1))
            }

            // Location
            fieldView(label: "Location *", icon: "mappin.circle.fill") {
                TextField("e.g. Curry Student Center, Boston", text: $viewModel.location)
                    .textFieldStyle(NEUTextFieldStyle())
            }

            // Price
            fieldView(label: "Price", icon: "dollarsign.circle.fill") {
                TextField("e.g. Free, $10, $5 - $20", text: $viewModel.price)
                    .textFieldStyle(NEUTextFieldStyle())
            }

            // Dates
            HStack(spacing: AppTheme.Spacing.sm) {
                fieldView(label: "Start *", icon: "calendar") {
                    DatePicker("", selection: $viewModel.startDate)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                }
                fieldView(label: "End *", icon: "calendar.badge.checkmark") {
                    DatePicker("", selection: $viewModel.endDate, in: viewModel.startDate...)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radius.md)
                }
            }

            // Image URL
            fieldView(label: "Image URL", icon: "photo.fill") {
                TextField("https://...", text: $viewModel.imageURL)
                    .textFieldStyle(NEUTextFieldStyle())
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }

            // Register Link
            fieldView(label: "Registration URL", icon: "link") {
                TextField("https://northeastern.edu/events/...", text: $viewModel.registerLink)
                    .textFieldStyle(NEUTextFieldStyle())
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }
        }
    }

    @ViewBuilder
    private func fieldView<Content: View>(label: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(AppTheme.Colors.brand)
                    .font(.caption)
                Text(label)
                    .font(AppTheme.Typography.caption())
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
            .padding(.leading, 4)
            content()
        }
    }

    // MARK: - Submit button
    private var submitButton: some View {
        Button {
            Task {
                await viewModel.addEvent(createdBy: authService.currentUser?.id ?? "admin")
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView().progressViewStyle(.circular).tint(.white)
                } else {
                    Image(systemName: "plus.circle.fill")
                    Text("Publish Event")
                }
            }
            .primaryButton()
        }
        .disabled(viewModel.isLoading || !viewModel.isFormValid)
        .opacity(viewModel.isFormValid ? 1.0 : 0.6)
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(.ultraThinMaterial)
    }

    // MARK: - Success toast
    private var successToast: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppTheme.Colors.success)
            Text("Event published successfully!")
                .font(AppTheme.Typography.bodyMedium())
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.full)
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.top, 60)
    }
}

#Preview {
    AddEventView(viewModel: AdminViewModel())
        .environmentObject(AuthService.shared)
        .background(AppTheme.Colors.background)
}
