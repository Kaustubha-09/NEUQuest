import Foundation
import Combine

// MARK: - TripService
// NOTE: Replace mock storage with Firestore when Firebase SDK is added via SPM.
@MainActor
final class TripService: ObservableObject {
    static let shared = TripService()

    @Published var trips: [Trip] = []
    @Published var isLoading: Bool = false

    private let storageKey = "neu_trips_db"

    private init() {
        loadTrips()
    }

    private func loadTrips() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let stored = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = stored
        } else {
            trips = Trip.mockTrips
            saveTrips()
        }
    }

    private func saveTrips() {
        if let data = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Fetch
    func fetchTrips() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        loadTrips()
        isLoading = false
    }

    // MARK: - Trips for user
    func trips(for userID: String, plannedIDs: [String]) -> [Trip] {
        trips.filter { plannedIDs.contains($0.id) }
    }

    // MARK: - Create trip
    func createTrip(_ trip: Trip) {
        trips.insert(trip, at: 0)
        saveTrips()
    }

    // MARK: - Delete trip
    func deleteTrip(id: String) {
        trips.removeAll { $0.id == id }
        saveTrips()
    }

    // MARK: - Get trip by ID
    func trip(id: String) -> Trip? {
        trips.first { $0.id == id }
    }

    // MARK: - Update trip
    func updateTrip(_ trip: Trip) {
        guard let index = trips.firstIndex(where: { $0.id == trip.id }) else { return }
        trips[index] = trip
        saveTrips()
    }
}
