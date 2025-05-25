import SwiftUI

struct HomeView: View {

    // MARK: – Environment & shared data
    @EnvironmentObject private var settings: UserSettings
    @StateObject private var scores = ScoreStore()

    // MARK: – Persisted settings (the "22 ints/bools")
    // ── Time limit ─────────────────────────────────────────────
    @AppStorage("timeLimit") private var timeLimit = 60

    // ── Addition settings (pulled from ContentView) ───────────────
    @AppStorage("additionEnabled") private var enableAddition = true
    @AppStorage("lbaddition1") private var lbaddition1: String = "2"
    @AppStorage("ubaddition1") private var ubaddition1: String = "100"
    @AppStorage("lbaddition2") private var lbaddition2: String = "2"
    @AppStorage("ubaddition2") private var ubaddition2: String = "100"

    // ── Subtraction settings ──────────────────────────────────────
    @AppStorage("subtractionEnabled") private var enableSubtraction = true
    @AppStorage("lbsubtraction1") private var lbsubtraction1: String = "2"
    @AppStorage("ubsubtraction1") private var ubsubtraction1: String = "100"
    @AppStorage("lbsubtraction2") private var lbsubtraction2: String = "2"
    @AppStorage("ubsubtraction2") private var ubsubtraction2: String = "100"

    // ── Multiplication settings ───────────────────────────────────
    @AppStorage("multiplicationEnabled") private var enableMultiplication = true
    @AppStorage("lbmultiplication1") private var lbmultiplication1: String = "2"
    @AppStorage("ubmultiplication1") private var ubmultiplication1: String = "12"
    @AppStorage("lbmultiplication2") private var lbmultiplication2: String = "2"
    @AppStorage("ubmultiplication2") private var ubmultiplication2: String = "100"

    // ── Division settings ─────────────────────────────────────────
    @AppStorage("divisionEnabled") private var enableDivision = true
    @AppStorage("lbdivision1") private var lbdivision1: String = "2"
    @AppStorage("ubdivision1") private var ubdivision1: String = "100"
    @AppStorage("lbdivision2") private var lbdivision2: String = "2"
    @AppStorage("ubdivision2") private var ubdivision2: String = "12"

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
            timeLimit: timeLimit,
            
            // Pass individual operand ranges for addition
            lowerAddition1: Int(lbaddition1) ?? 2,
            upperAddition1: Int(ubaddition1) ?? 100,
            lowerAddition2: Int(lbaddition2) ?? 2,
            upperAddition2: Int(ubaddition2) ?? 100,
            
            // Pass individual operand ranges for subtraction
            lowerSubtraction1: Int(lbsubtraction1) ?? 2,
            upperSubtraction1: Int(ubsubtraction1) ?? 100,
            lowerSubtraction2: Int(lbsubtraction2) ?? 2,
            upperSubtraction2: Int(ubsubtraction2) ?? 100,
            
            // Pass individual operand ranges for multiplication
            lowerMultiplication1: Int(lbmultiplication1) ?? 2,
            upperMultiplication1: Int(ubmultiplication1) ?? 12,
            lowerMultiplication2: Int(lbmultiplication2) ?? 2,
            upperMultiplication2: Int(ubmultiplication2) ?? 100,
            
            // Pass individual operand ranges for division
            lowerDivision1: Int(lbdivision1) ?? 2,
            upperDivision1: Int(ubdivision1) ?? 100,
            lowerDivision2: Int(lbdivision2) ?? 2,
            upperDivision2: Int(ubdivision2) ?? 100,
            
            enableAddition: enableAddition,
            enableSubtraction: enableSubtraction,
            enableMultiplication: enableMultiplication,
            enableDivision: enableDivision
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
