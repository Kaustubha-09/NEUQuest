import SwiftUI

struct BudgetRangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    var range: ClosedRange<Double> = 0...1000
    var step: Double = 10

    @State private var isDraggingMin: Bool = false
    @State private var isDraggingMax: Bool = false

    private let trackHeight: CGFloat = 4
    private let thumbSize: CGFloat = 24

    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            // Labels
            HStack {
                Label {
                    Text(formatCurrency(minValue))
                        .font(AppTheme.Typography.bodyMedium())
                        .foregroundColor(AppTheme.Colors.gold)
                } icon: {
                    Text("Min")
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
                Spacer()
                Label {
                    Text(formatCurrency(maxValue))
                        .font(AppTheme.Typography.bodyMedium())
                        .foregroundColor(AppTheme.Colors.gold)
                } icon: {
                    Text("Max")
                        .font(AppTheme.Typography.caption())
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }
            }

            // Track
            GeometryReader { geo in
                let width = geo.size.width
                let minX = CGFloat((minValue - range.lowerBound) / (range.upperBound - range.lowerBound)) * width
                let maxX = CGFloat((maxValue - range.lowerBound) / (range.upperBound - range.lowerBound)) * width

                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(AppTheme.Colors.surfaceElevated)
                        .frame(height: trackHeight)

                    // Selected range
                    Capsule()
                        .fill(AppTheme.Colors.brand)
                        .frame(width: max(0, maxX - minX), height: trackHeight)
                        .offset(x: minX)

                    // Min thumb
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .overlay(Circle().stroke(AppTheme.Colors.brand, lineWidth: 2))
                        .offset(x: minX - thumbSize / 2)
                        .scaleEffect(isDraggingMin ? 1.2 : 1.0)
                        .animation(.spring(response: 0.2), value: isDraggingMin)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDraggingMin = true
                                    let newX = min(max(0, value.location.x), maxX - thumbSize)
                                    let newValue = range.lowerBound + Double(newX / width) * (range.upperBound - range.lowerBound)
                                    minValue = (newValue / step).rounded() * step
                                    minValue = max(range.lowerBound, min(minValue, maxValue - step))
                                }
                                .onEnded { _ in isDraggingMin = false }
                        )

                    // Max thumb
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .overlay(Circle().stroke(AppTheme.Colors.brand, lineWidth: 2))
                        .offset(x: maxX - thumbSize / 2)
                        .scaleEffect(isDraggingMax ? 1.2 : 1.0)
                        .animation(.spring(response: 0.2), value: isDraggingMax)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDraggingMax = true
                                    let newX = min(max(minX + thumbSize, value.location.x), width)
                                    let newValue = range.lowerBound + Double(newX / width) * (range.upperBound - range.lowerBound)
                                    maxValue = (newValue / step).rounded() * step
                                    maxValue = min(range.upperBound, max(maxValue, minValue + step))
                                }
                                .onEnded { _ in isDraggingMax = false }
                        )
                }
            }
            .frame(height: thumbSize)
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$\(Int(value))"
    }
}

#Preview {
    BudgetRangeSlider(minValue: .constant(50), maxValue: .constant(350))
        .padding()
        .background(AppTheme.Colors.background)
}
