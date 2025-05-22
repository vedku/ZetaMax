import SwiftUI
import Combine   // needed for ObservableObject publisher

/// Stores global appearance preferences.
final class UserSettings: ObservableObject {

    /// Backed by UserDefaults via `@AppStorage`.
    @AppStorage("isDarkMode") private var storedDark = false {
        willSet { objectWillChange.send() }   // notify views
    }

    /// Public property your views bind to.
    var isDarkMode: Bool {
        get { storedDark }
        set { storedDark = newValue }
    }
}
