import SwiftUI

@main
struct NEUQuestApp: App {
    @StateObject private var authService = AuthService.shared
    @StateObject private var eventService = EventService.shared
    @StateObject private var tripService = TripService.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
                .environmentObject(eventService)
                .environmentObject(tripService)
                .preferredColorScheme(.dark)
                .tint(AppTheme.Colors.brand)
        }
    }
}
