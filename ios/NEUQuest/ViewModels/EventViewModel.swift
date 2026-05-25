import Foundation
import Combine

@MainActor
final class EventViewModel: ObservableObject {
    @Published var selectedCategory: EventCategory?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var newCommentText: String = ""
    @Published var showReportConfirm: Bool = false
    @Published var showAddedToast: Bool = false

    private let eventService = EventService.shared

    // MARK: - Filtered events for RightNow view
    var displayedEvents: [Event] {
        let base = eventService.filteredEvents(category: selectedCategory)
        guard !searchText.isEmpty else { return base }
        return base.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.location.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var allEvents: [Event] { eventService.events }

    // MARK: - Fetch
    func fetchEvents() async {
        isLoading = true
        await eventService.fetchEvents()
        isLoading = false
    }

    // MARK: - Report event
    func reportEvent(id: String) {
        eventService.reportEvent(id: id)
        showReportConfirm = false
    }

    // MARK: - Add comment
    func addComment(to eventID: String, commenterName: String) {
        guard !newCommentText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let comment = Comment(
            id: UUID().uuidString,
            text: newCommentText.trimmingCharacters(in: .whitespaces),
            timestamp: Date().timeIntervalSince1970,
            commenterName: commenterName
        )
        eventService.addComment(comment, to: eventID)
        newCommentText = ""
    }

    // MARK: - Get event by ID
    func event(id: String) -> Event? {
        eventService.events.first { $0.id == id }
    }

    // MARK: - Category selection
    func toggleCategory(_ category: EventCategory) {
        selectedCategory = selectedCategory == category ? nil : category
    }

    // MARK: - Live badge
    func isLive(_ event: Event) -> Bool {
        event.isHappeningNow
    }
}
