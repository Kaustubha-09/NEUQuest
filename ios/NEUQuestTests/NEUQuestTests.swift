import XCTest
@testable import NEUQuest

final class NEUQuestTests: XCTestCase {

    // MARK: - Email Validation Tests

    func testValidNEUNortheasternEmail() {
        XCTAssertTrue("john.doe@northeastern.edu".isValidNEUEmail)
        XCTAssertTrue("student@northeastern.edu".isValidNEUEmail)
        XCTAssertTrue("STUDENT@NORTHEASTERN.EDU".isValidNEUEmail)
    }

    func testValidNEUHuskyEmail() {
        XCTAssertTrue("john.doe@husky.neu.edu".isValidNEUEmail)
        XCTAssertTrue("student@husky.neu.edu".isValidNEUEmail)
        XCTAssertTrue("STUDENT@HUSKY.NEU.EDU".isValidNEUEmail)
    }

    func testInvalidNEUEmails() {
        XCTAssertFalse("john.doe@gmail.com".isValidNEUEmail)
        XCTAssertFalse("student@mit.edu".isValidNEUEmail)
        XCTAssertFalse("student@boston.edu".isValidNEUEmail)
        XCTAssertFalse("student@neu.edu".isValidNEUEmail)         // neu.edu is not valid
        XCTAssertFalse("@northeastern.edu".isValidNEUEmail)
        XCTAssertFalse("notanemail".isValidNEUEmail)
        XCTAssertFalse("".isValidNEUEmail)
    }

    // MARK: - Event Date Range Tests

    func testEventInDateRange() {
        // Event on May 5
        var event = Event.mockEvents[0]
        // Override dates for testing
        event = Event(
            id: "test1",
            title: "Test Event",
            description: "Test",
            category: "Art",
            location: "Boston",
            price: "Free",
            startDate: "05/05/2026",
            endDate: "05/05/2026",
            startTime: "10:00",
            endTime: "18:00",
            imageURL: "",
            registerLink: "",
            createdBy: "admin1",
            isReported: false,
            comments: []
        )

        let start = Date.fromNEU(date: "04/05/2026")!
        let end = Date.fromNEU(date: "06/05/2026")!
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end)!
        let eventStart = event.startDateObject!

        XCTAssertTrue(eventStart >= start && eventStart <= endOfDay, "Event should be in date range")
    }

    func testEventOutsideDateRange() {
        let event = Event(
            id: "test2",
            title: "Future Event",
            description: "Test",
            category: "Music",
            location: "Boston",
            price: "$10",
            startDate: "15/06/2026",
            endDate: "15/06/2026",
            startTime: "19:00",
            endTime: "22:00",
            imageURL: "",
            registerLink: "",
            createdBy: "admin1",
            isReported: false,
            comments: []
        )

        let start = Date.fromNEU(date: "04/05/2026")!
        let end = Date.fromNEU(date: "06/05/2026")!
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end)!
        let eventStart = event.startDateObject!

        XCTAssertFalse(eventStart >= start && eventStart <= endOfDay, "Event should NOT be in date range")
    }

    func testEventHappeningNow() {
        let now = Date()
        let cal = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let pastDate = cal.date(byAdding: .hour, value: -1, to: now)!
        let futureDate = cal.date(byAdding: .hour, value: 1, to: now)!

        let event = Event(
            id: "live1",
            title: "Live Event",
            description: "Happening right now",
            category: "Music",
            location: "Boston",
            price: "Free",
            startDate: formatter.string(from: pastDate),
            endDate: formatter.string(from: futureDate),
            startTime: timeFormatter.string(from: pastDate),
            endTime: timeFormatter.string(from: futureDate),
            imageURL: "",
            registerLink: "",
            createdBy: "admin1",
            isReported: false,
            comments: []
        )

        XCTAssertTrue(event.isHappeningNow, "Event starting in the past and ending in the future should be live")
    }

    func testEventIsUpcoming() {
        let future = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let event = Event(
            id: "upcoming1",
            title: "Upcoming Event",
            description: "Not yet",
            category: "Art",
            location: "Boston",
            price: "$5",
            startDate: formatter.string(from: future),
            endDate: formatter.string(from: future),
            startTime: timeFormatter.string(from: future),
            endTime: timeFormatter.string(from: future),
            imageURL: "",
            registerLink: "",
            createdBy: "admin1",
            isReported: false,
            comments: []
        )

        XCTAssertTrue(event.isUpcoming, "Event starting in the future should be upcoming")
        XCTAssertFalse(event.isHappeningNow, "Upcoming event should not be live")
    }

    // MARK: - Trip Model Tests

    func testTripMealsIncluded() {
        var trip = Trip.mockTrips[0]
        XCTAssertTrue(trip.isMealsIncluded)
        trip.isMealsIncluded = false
        XCTAssertEqual(trip.mealsIncluded, "no")
        trip.isMealsIncluded = true
        XCTAssertEqual(trip.mealsIncluded, "yes")
    }

    func testTripTransportIncluded() {
        var trip = Trip.mockTrips[1]
        XCTAssertTrue(trip.isTransportIncluded)
        trip.isTransportIncluded = false
        XCTAssertEqual(trip.transportIncluded, "no")
    }

    func testTripDurationDays() {
        let trip = Trip(
            id: "t",
            title: "3 Day Trip",
            location: "Boston",
            startDate: "10/05/2026",
            endDate: "12/05/2026",
            startTime: "09:00",
            endTime: "18:00",
            minBudget: 50,
            maxBudget: 200,
            mealsIncluded: "yes",
            transportIncluded: "no",
            eventIDs: []
        )
        XCTAssertEqual(trip.durationDays, 3)
    }

    // MARK: - Date Formatter Tests

    func testNEUDateParsing() {
        let date = Date.fromNEU(date: "04/05/2026", time: "10:30")
        XCTAssertNotNil(date)

        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date!)
        XCTAssertEqual(components.day, 4)
        XCTAssertEqual(components.month, 5)
        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.hour, 10)
        XCTAssertEqual(components.minute, 30)
    }

    func testNEUDateFormatterRoundTrip() {
        let dateStr = "15/08/2026"
        let date = Date.fromNEU(date: dateStr)
        XCTAssertNotNil(date)
        XCTAssertEqual(date?.neuDateString, dateStr)
    }

    // MARK: - User Model Tests

    func testUserInitials() {
        let user = User.mockCurrentUser
        XCTAssertEqual(user.initials, "AH")
    }

    func testUserInitialsSingleName() {
        let user = User(
            id: "u", name: "Madonna", email: "test@northeastern.edu",
            campus: "Boston", interests: [], profileImageURL: "",
            plannedTrips: [], eventsAttended: [], isAdmin: false, isEmailVerified: true
        )
        XCTAssertEqual(user.initials, "MA")
    }

    // MARK: - Comment Tests

    func testCommentDateConversion() {
        let timestamp = Date().timeIntervalSince1970
        let comment = Comment(id: "c1", text: "Test", timestamp: timestamp, commenterName: "Alex")
        let diff = abs(comment.date.timeIntervalSince1970 - timestamp)
        XCTAssertLessThan(diff, 1.0, "Comment date should match timestamp")
    }

    // MARK: - String Extension Tests

    func testStringTruncation() {
        let long = "This is a very long string that should be truncated"
        XCTAssertEqual(long.truncated(to: 10), "This is a ...")
        XCTAssertEqual("Short".truncated(to: 10), "Short")
    }

    func testIsValidEmail() {
        XCTAssertTrue("test@example.com".isValidEmail)
        XCTAssertFalse("notanemail".isValidEmail)
        XCTAssertFalse("@example.com".isValidEmail)
    }
}
