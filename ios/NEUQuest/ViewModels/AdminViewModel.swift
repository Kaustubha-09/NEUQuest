import Foundation
import Combine

@MainActor
final class AdminViewModel: ObservableObject {
    // MARK: - Add Event form
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var category: String = EventCategory.art.rawValue
    @Published var location: String = ""
    @Published var price: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var imageURL: String = ""
    @Published var registerLink: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var showSuccessToast: Bool = false

    private let eventService = EventService.shared

    // MARK: - Reported events
    var reportedEvents: [Event] { eventService.reportedEvents }

    // MARK: - Approve event
    func approveEvent(id: String) {
        eventService.approveEvent(id: id)
    }

    // MARK: - Remove event
    func removeEvent(id: String) {
        eventService.removeEvent(id: id)
    }

    // MARK: - Add Event
    func addEvent(createdBy userID: String) async {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            showError = true
            return
        }

        isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)

        let event = Event(
            id: UUID().uuidString,
            title: title.trimmingCharacters(in: .whitespaces),
            description: description.trimmingCharacters(in: .whitespaces),
            category: category,
            location: location.trimmingCharacters(in: .whitespaces),
            price: price.isEmpty ? "Free" : price.trimmingCharacters(in: .whitespaces),
            startDate: startDate.neuDateString,
            endDate: endDate.neuDateString,
            startTime: startDate.neuTimeString,
            endTime: endDate.neuTimeString,
            imageURL: imageURL.trimmingCharacters(in: .whitespaces),
            registerLink: registerLink.trimmingCharacters(in: .whitespaces),
            createdBy: userID,
            isReported: false,
            comments: []
        )

        eventService.addEvent(event)
        isLoading = false
        showSuccessToast = true
        resetForm()
    }

    // MARK: - Validation
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !location.trimmingCharacters(in: .whitespaces).isEmpty &&
        startDate <= endDate
    }

    // MARK: - Reset form
    func resetForm() {
        title = ""
        description = ""
        category = EventCategory.art.rawValue
        location = ""
        price = ""
        startDate = Date()
        endDate = Date()
        imageURL = ""
        registerLink = ""
        errorMessage = nil
        showError = false
    }
}
