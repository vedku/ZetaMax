import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Toggle("Enable Dark Mode", isOn: .constant(true))
                .padding()

            Toggle("Enable Notifications", isOn: .constant(false))
                .padding()

            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
