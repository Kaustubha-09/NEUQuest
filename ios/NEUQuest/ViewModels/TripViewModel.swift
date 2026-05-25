import Foundation
import Combine

@MainActor
final class TripViewModel: ObservableObject {
    // MARK: - Form state
    @Published var tripTitle: String = ""
    @Published var tripLocation: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
    @Published var minBudget: Double = 0
    @Published var maxBudget: Double = 200
    @Published var mealsIncluded: Bool = false
    @Published var transportIncluded: Bool = false

    // MARK: - State
    @Published var isGeneratingTitle: Bool = false
    @Published var isCreatingTrip: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var matchedEvents: [Event] = []

    private let tripService = TripService.shared
    private let eventService = EventService.shared
    private let geminiService = GeminiService.shared

    // MARK: - Trips (all)
    var allTrips: [Trip] { tripService.trips }

    // MARK: - Trips for current user
    func userTrips(plannedIDs: [String]) -> [Trip] {
        tripService.trips.filter { plannedIDs.contains($0.id) }
    }

    // MARK: - Events in trip
    func events(for trip: Trip) -> [Event] {
        trip.eventIDs.compactMap { id in
            eventService.events.first { $0.id == id }
        }.sorted {
            ($0.startDateObject ?? .distantFuture) < ($1.startDateObject ?? .distantFuture)
        }
    }

    // MARK: - Auto-match events in date range
    func matchEvents() {
        let startStr = startDate.neuDateString
        let endStr = endDate.neuDateString
        matchedEvents = eventService.events(from: startStr, to: endStr)
    }

    // MARK: - AI Generate trip title
    func generateTitle(interests: [String]) async {
        isGeneratingTitle = true
        do {
            let generated = try await geminiService.generateTripName(
                location: tripLocation.isEmpty ? "Boston" : tripLocation,
                startDate: startDate.neuDateString,
                endDate: endDate.neuDateString,
                interests: interests
            )
            tripTitle = generated
        } catch {
            // Silently use fallback (already handled in GeminiService)
            tripTitle = "\(tripLocation.isEmpty ? "Boston" : tripLocation) Adventure"
        }
        isGeneratingTitle = false
    }

    // MARK: - Create trip
    func createTrip(for userID: String) -> Trip? {
        guard !tripTitle.trimmingCharacters(in: .whitespaces).isEmpty,
              !tripLocation.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return nil
        }

        guard startDate <= endDate else {
            errorMessage = "End date must be after start date"
            showError = true
            return nil
        }

        guard minBudget <= maxBudget else {
            errorMessage = "Minimum budget cannot exceed maximum budget"
            showError = true
            return nil
        }

        matchEvents()

        let trip = Trip(
            id: UUID().uuidString,
            title: tripTitle.trimmingCharacters(in: .whitespaces),
            location: tripLocation.trimmingCharacters(in: .whitespaces),
            startDate: startDate.neuDateString,
            endDate: endDate.neuDateString,
            startTime: "09:00",
            endTime: "18:00",
            minBudget: minBudget,
            maxBudget: maxBudget,
            mealsIncluded: mealsIncluded ? "yes" : "no",
            transportIncluded: transportIncluded ? "yes" : "no",
            eventIDs: matchedEvents.map { $0.id }
        )

        tripService.createTrip(trip)
        resetForm()
        return trip
    }

    // MARK: - Delete trip
    func deleteTrip(id: String) {
        tripService.deleteTrip(id: id)
    }

    // MARK: - Reset form
    func resetForm() {
        tripTitle = ""
        tripLocation = ""
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        minBudget = 0
        maxBudget = 200
        mealsIncluded = false
        transportIncluded = false
        matchedEvents = []
        errorMessage = nil
        showError = false
    }

    // MARK: - Validation
    var isFormValid: Bool {
        !tripTitle.trimmingCharacters(in: .whitespaces).isEmpty &&
        !tripLocation.trimmingCharacters(in: .whitespaces).isEmpty &&
        startDate <= endDate &&
        minBudget <= maxBudget
    }
}
