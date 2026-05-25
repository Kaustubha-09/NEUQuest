import Foundation

// MARK: - Event Category
enum EventCategory: String, CaseIterable, Codable {
    case art = "Art"
    case nature = "Nature"
    case photography = "Photography"
    case travel = "Travel"
    case music = "Music"
    case movies = "Movies"
    case food = "Food"
    case sports = "Sports"

    var icon: String {
        switch self {
        case .art: return "paintpalette.fill"
        case .nature: return "leaf.fill"
        case .photography: return "camera.fill"
        case .travel: return "airplane"
        case .music: return "music.note"
        case .movies: return "film.fill"
        case .food: return "fork.knife"
        case .sports: return "sportscourt.fill"
        }
    }
}

// MARK: - Event Model
struct Event: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var description: String
    var category: String          // raw EventCategory value
    var location: String
    var price: String             // e.g. "Free", "$10", "$5 - $15"
    var startDate: String         // dd/MM/yyyy
    var endDate: String           // dd/MM/yyyy
    var startTime: String         // HH:mm
    var endTime: String           // HH:mm
    var imageURL: String
    var registerLink: String
    var createdBy: String         // userID
    var isReported: Bool
    var comments: [Comment]

    // MARK: Computed
    var categoryEnum: EventCategory? { EventCategory(rawValue: category) }

    var startDateObject: Date? { Date.fromNEU(date: startDate, time: startTime) }
    var endDateObject: Date? { Date.fromNEU(date: endDate, time: endTime) }

    var isHappeningNow: Bool {
        guard let start = startDateObject, let end = endDateObject else { return false }
        let now = Date()
        return now >= start && now <= end
    }

    var isUpcoming: Bool {
        guard let start = startDateObject else { return false }
        return start > Date()
    }

    var formattedDateRange: String {
        guard let start = startDateObject else { return "\(startDate) \(startTime)" }
        let end = endDateObject
        let startStr = start.displayDateTimeString
        if let end = end {
            return "\(startStr) – \(end.displayDateTimeString)"
        }
        return startStr
    }

    var formattedPrice: String {
        price.isEmpty ? "Free" : price
    }

    static func == (lhs: Event, rhs: Event) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Mock Events
extension Event {
    static let mockEvents: [Event] = [
        Event(
            id: "evt1",
            title: "NEU Arts Festival 2025",
            description: "A vibrant celebration of student and faculty artwork. Explore paintings, sculptures, digital installations, and live performances across the Fenway campus. Connect with artists and immerse yourself in the creative culture at Northeastern.",
            category: "Art",
            location: "Curry Student Center, Boston",
            price: "Free",
            startDate: "04/05/2026",
            endDate: "04/05/2026",
            startTime: "10:00",
            endTime: "18:00",
            imageURL: "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=800",
            registerLink: "https://northeastern.edu/events/arts-festival",
            createdBy: "admin1",
            isReported: false,
            comments: [
                Comment(id: "c1", text: "This looks amazing!", timestamp: Date().timeIntervalSince1970 - 3600, commenterName: "Alex T."),
                Comment(id: "c2", text: "Can't wait to attend!", timestamp: Date().timeIntervalSince1970 - 1800, commenterName: "Maya S.")
            ]
        ),
        Event(
            id: "evt2",
            title: "Fenway Park Photography Walk",
            description: "Join us for a guided photography walk around Fenway Park and the surrounding neighborhoods. Perfect for beginner and intermediate photographers. Tips on composition, lighting, and urban photography will be shared throughout.",
            category: "Photography",
            location: "Fenway Park, Boston",
            price: "$5",
            startDate: "04/05/2026",
            endDate: "04/05/2026",
            startTime: "09:00",
            endTime: "12:00",
            imageURL: "https://images.unsplash.com/photo-1543351611-58f69d7c1781?w=800",
            registerLink: "https://northeastern.edu/events/photo-walk",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt3",
            title: "Boston Jazz Night",
            description: "An evening of smooth jazz featuring student musicians from the College of Arts, Media and Design. Enjoy live performances in an intimate setting with food and drinks available for purchase.",
            category: "Music",
            location: "CAMD Building, Boston",
            price: "$10",
            startDate: "05/05/2026",
            endDate: "05/05/2026",
            startTime: "19:00",
            endTime: "22:00",
            imageURL: "https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=800",
            registerLink: "https://northeastern.edu/events/jazz-night",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt4",
            title: "Emerald Necklace Nature Walk",
            description: "Explore Boston's beautiful Emerald Necklace park system with a guided nature walk. Learn about local flora, fauna, and the history of Frederick Law Olmsted's masterpiece green space.",
            category: "Nature",
            location: "Franklin Park, Boston",
            price: "Free",
            startDate: "06/05/2026",
            endDate: "06/05/2026",
            startTime: "08:00",
            endTime: "11:00",
            imageURL: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
            registerLink: "https://northeastern.edu/events/nature-walk",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt5",
            title: "Boston Food Tour: North End",
            description: "Taste your way through Boston's historic North End neighborhood. Sample Italian pastries, fresh pasta, and classic New England seafood while learning about the neighborhood's rich cultural history.",
            category: "Food",
            location: "North End, Boston",
            price: "$25",
            startDate: "07/05/2026",
            endDate: "07/05/2026",
            startTime: "14:00",
            endTime: "17:00",
            imageURL: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
            registerLink: "https://northeastern.edu/events/food-tour",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt6",
            title: "Cape Cod Day Trip",
            description: "A one-day trip to Cape Cod! We'll visit Provincetown, Race Point Beach, and the Cape Cod National Seashore. Transportation from Northeastern's campus is included in the ticket price.",
            category: "Travel",
            location: "Cape Cod, Massachusetts",
            price: "$35",
            startDate: "10/05/2026",
            endDate: "10/05/2026",
            startTime: "07:00",
            endTime: "20:00",
            imageURL: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
            registerLink: "https://northeastern.edu/events/cape-cod",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt7",
            title: "NEU Huskies vs. Boston University",
            description: "Cheer on the Northeastern Huskies in this exciting hockey rivalry game against Boston University. Student tickets are discounted with valid NEU ID. Show your Husky pride!",
            category: "Sports",
            location: "Matthews Arena, Boston",
            price: "$8",
            startDate: "08/05/2026",
            endDate: "08/05/2026",
            startTime: "19:30",
            endTime: "22:00",
            imageURL: "https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800",
            registerLink: "https://northeastern.edu/events/huskies-game",
            createdBy: "admin1",
            isReported: false,
            comments: []
        ),
        Event(
            id: "evt8",
            title: "Outdoor Cinema: Classic Films",
            description: "Enjoy classic films under the stars on the Centennial Common. Blankets and lawn chairs welcome. Popcorn and snacks will be available. This week's film: Casablanca.",
            category: "Movies",
            location: "Centennial Common, Boston",
            price: "Free",
            startDate: "09/05/2026",
            endDate: "09/05/2026",
            startTime: "21:00",
            endTime: "23:30",
            imageURL: "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800",
            registerLink: "https://northeastern.edu/events/outdoor-cinema",
            createdBy: "admin1",
            isReported: false,
            comments: []
        )
    ]
}
