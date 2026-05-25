import Foundation

// MARK: - Trip Model
struct Trip: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var location: String
    var startDate: String         // dd/MM/yyyy
    var endDate: String           // dd/MM/yyyy
    var startTime: String         // HH:mm
    var endTime: String           // HH:mm
    var minBudget: Double
    var maxBudget: Double
    var mealsIncluded: String     // "yes" / "no"
    var transportIncluded: String // "yes" / "no"
    var eventIDs: [String]

    // MARK: Computed
    var startDateObject: Date? { Date.fromNEU(date: startDate, time: startTime) }
    var endDateObject: Date? { Date.fromNEU(date: endDate, time: endTime) }

    var isMealsIncluded: Bool {
        get { mealsIncluded.lowercased() == "yes" }
        set { mealsIncluded = newValue ? "yes" : "no" }
    }

    var isTransportIncluded: Bool {
        get { transportIncluded.lowercased() == "yes" }
        set { transportIncluded = newValue ? "yes" : "no" }
    }

    var formattedBudgetRange: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        let minStr = formatter.string(from: NSNumber(value: minBudget)) ?? "$\(Int(minBudget))"
        let maxStr = formatter.string(from: NSNumber(value: maxBudget)) ?? "$\(Int(maxBudget))"
        return "\(minStr) – \(maxStr)"
    }

    var formattedDateRange: String {
        guard let start = startDateObject, let end = endDateObject else {
            return "\(startDate) – \(endDate)"
        }
        return "\(start.displayDateString) – \(end.displayDateString)"
    }

    var durationDays: Int {
        guard let start = startDateObject, let end = endDateObject else { return 1 }
        let days = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        return max(1, days + 1)
    }

    static func == (lhs: Trip, rhs: Trip) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Mock Trips
extension Trip {
    static let mockTrips: [Trip] = [
        Trip(
            id: "trip1",
            title: "Boston Spring Weekend Getaway",
            location: "Boston, MA",
            startDate: "10/05/2026",
            endDate: "12/05/2026",
            startTime: "09:00",
            endTime: "18:00",
            minBudget: 50,
            maxBudget: 150,
            mealsIncluded: "yes",
            transportIncluded: "no",
            eventIDs: ["evt1", "evt2", "evt3"]
        ),
        Trip(
            id: "trip2",
            title: "Cape Cod Coastal Escape",
            location: "Cape Cod, MA",
            startDate: "10/05/2026",
            endDate: "11/05/2026",
            startTime: "07:00",
            endTime: "20:00",
            minBudget: 100,
            maxBudget: 300,
            mealsIncluded: "no",
            transportIncluded: "yes",
            eventIDs: ["evt6"]
        )
    ]
}
