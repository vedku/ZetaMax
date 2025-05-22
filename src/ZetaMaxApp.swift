import SwiftUI

@main
struct ZetaMaxApp: App {
    @StateObject private var settings = UserSettings()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
