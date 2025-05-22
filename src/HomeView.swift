

import SwiftUI

struct HomeView: View {

    // MARK: – Environment & shared data
    @EnvironmentObject private var settings: UserSettings
    @StateObject          private var scores   = ScoreStore()

    // MARK: – Persisted settings (the “22 ints/bools”)
    // ── Time limit ─────────────────────────────────────────────
    @AppStorage("timeLimit")                private var timeLimit                = 60

    // ── Addition bounds & toggle ───────────────────────────────
    @AppStorage("lowerAddition")            private var lowerAddition            = 1
    @AppStorage("upperAddition")            private var upperAddition            = 20
    @AppStorage("enableAddition")           private var enableAddition           = true

    // ── Subtraction bounds & toggle ────────────────────────────
    @AppStorage("lowerSubtraction")         private var lowerSubtraction         = 1
    @AppStorage("upperSubtraction")         private var upperSubtraction         = 20
    @AppStorage("enableSubtraction")        private var enableSubtraction        = true

    // ── Multiplication bounds & toggle ─────────────────────────
    @AppStorage("lowerMultiplication")      private var lowerMultiplication      = 1
    @AppStorage("upperMultiplication")      private var upperMultiplication      = 12
    @AppStorage("enableMultiplication")     private var enableMultiplication     = true

    // ── Division bounds & toggle ───────────────────────────────
    @AppStorage("lowerDivision")            private var lowerDivision            = 1
    @AppStorage("upperDivision")            private var upperDivision            = 12
    @AppStorage("enableDivision")           private var enableDivision           = false

    // MARK: – Local state
    @State private var showOpsAlert = false

    // MARK: – Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {

                // ── Title ──────────────────────────────────────
                Text("ZetaMax")
                    .font(.system(size: 64))
                    .padding(.bottom, 250)
                
                // ── Play button ───────────────────────────────
                NavigationLink {
                    GameView(config: gameConfig)
                        .environmentObject(scores)
                } label: {
                    Text("Play Game")
                        .frame(maxWidth: 240)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isAnyOperationEnabled)        // disable if no ops
                .simultaneousGesture(TapGesture().onEnded {
                    if !isAnyOperationEnabled { showOpsAlert = true }
                })

                // ── Settings & stats ──────────────────────────
                NavigationLink("Settings") { ContentView() }
                NavigationLink("Progress") {
                    ScoreGraphView()
                        .environmentObject(scores)
                }

                // ── Dark / light toggle ───────────────────────
                Button {
                    settings.isDarkMode.toggle()
                } label: {
                    Image(systemName: settings.isDarkMode ? "sun.max.fill"
                                                          : "moon.fill")
                        .font(.title2)
                        .padding(12)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(settings.isDarkMode
                                    ? "Switch to light mode"
                                    : "Switch to dark mode")

                Spacer(minLength: 24)
            }
            .padding()
            .alert("Choose at least one operation",
                   isPresented: $showOpsAlert) { Button("OK", role: .cancel) { } }
        }
        // inject shared stores down the stack
        .environmentObject(scores)
    }

    // MARK: – Helpers
    /// Bundle up all settings into the struct GameView expects.
    private var gameConfig: GameView.Config {
        .init(
            timeLimit:               timeLimit,
            lowerAddition:           lowerAddition,
            upperAddition:           upperAddition,
            lowerSubtraction:        lowerSubtraction,
            upperSubtraction:        upperSubtraction,
            lowerMultiplication:     lowerMultiplication,
            upperMultiplication:     upperMultiplication,
            lowerDivision:           lowerDivision,
            upperDivision:           upperDivision,
            enableAddition:          enableAddition,
            enableSubtraction:       enableSubtraction,
            enableMultiplication:    enableMultiplication,
            enableDivision:          enableDivision
        )
    }

    /// Rejects play when every operation is off.
    private var isAnyOperationEnabled: Bool {
        enableAddition || enableSubtraction ||
        enableMultiplication || enableDivision
    }
}

// MARK: – Preview
#Preview {
    HomeView()
        .environmentObject(UserSettings())
}
