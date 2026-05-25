import Foundation

// MARK: - Comment Model
struct Comment: Identifiable, Codable, Hashable {
    var id: String
    var text: String
    var timestamp: TimeInterval   // Unix epoch seconds
    var commenterName: String

    var date: Date { Date(timeIntervalSince1970: timestamp) }

    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
