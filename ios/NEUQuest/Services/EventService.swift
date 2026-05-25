import Foundation
import Combine

// MARK: - EventService
// NOTE: Replace mock storage with Firestore when Firebase SDK is added via SPM.
@MainActor
final class EventService: ObservableObject {
    static let shared = EventService()

    @Published var events: [Event] = []
    @Published var isLoading: Bool = false

    private let storageKey = "neu_events_db"

    private init() {
        loadEvents()
    }

    // MARK: - Load events
    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let stored = try? JSONDecoder().decode([Event].self, from: data) {
            events = stored
        } else {
            // Seed mock data
            events = Event.mockEvents
            saveEvents()
        }
    }

    private func saveEvents() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Fetch (simulate network)
    func fetchEvents() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 600_000_000)
        loadEvents()
        isLoading = false
    }

    // MARK: - Get events happening now or upcoming (AI-ranked: happening now first, then upcoming by start date)
    var liveAndUpcomingEvents: [Event] {
        let now = events.filter { $0.isHappeningNow }
        let upcoming = events.filter { $0.isUpcoming }.sorted {
            ($0.startDateObject ?? .distantFuture) < ($1.startDateObject ?? .distantFuture)
        }
        return now + upcoming
    }

    // MARK: - Filter by category
    func events(for category: EventCategory) -> [Event] {
        events.filter { $0.category == category.rawValue }
    }

    func filteredEvents(category: EventCategory?) -> [Event] {
        guard let category else { return liveAndUpcomingEvents }
        let categoryEvents = events.filter { $0.category == category.rawValue }
        let now = categoryEvents.filter { $0.isHappeningNow }
        let upcoming = categoryEvents.filter { $0.isUpcoming }.sorted {
            ($0.startDateObject ?? .distantFuture) < ($1.startDateObject ?? .distantFuture)
        }
        return now + upcoming
    }

    // MARK: - Events in date range (for trip planner)
    func events(from startDate: String, to endDate: String) -> [Event] {
        guard let tripStart = Date.fromNEU(date: startDate),
              let tripEnd = Date.fromNEU(date: endDate) else { return [] }
        let tripEndOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: tripEnd) ?? tripEnd
        return events.filter { event in
            guard let eventStart = event.startDateObject else { return false }
            return eventStart >= tripStart && eventStart <= tripEndOfDay
        }
    }

    // MARK: - Add event
    func addEvent(_ event: Event) {
        events.insert(event, at: 0)
        saveEvents()
    }

    // MARK: - Add comment to event
    func addComment(_ comment: Comment, to eventID: String) {
        guard let index = events.firstIndex(where: { $0.id == eventID }) else { return }
        events[index].comments.append(comment)
        saveEvents()
    }

    // MARK: - Report event
    func reportEvent(id: String) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].isReported = true
        saveEvents()
    }

    // MARK: - Remove event (admin)
    func removeEvent(id: String) {
        events.removeAll { $0.id == id }
        saveEvents()
    }

    // MARK: - Approve (un-report) event (admin)
    func approveEvent(id: String) {
        guard let index = events.firstIndex(where: { $0.id == id }) else { return }
        events[index].isReported = false
        saveEvents()
    }

    // MARK: - Reported events
    var reportedEvents: [Event] {
        events.filter { $0.isReported }
    }
}
