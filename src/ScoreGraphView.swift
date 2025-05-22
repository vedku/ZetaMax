//
//  ScoreGraphView.swift
//  ZetaMax
//
//

import SwiftUI
import Charts

/// Shows the user’s progress for each selectable time-limit.
struct ScoreGraphView: View {

    // MARK: – Environment
    @EnvironmentObject private var store: ScoreStore          // shared persistence

    // MARK: – UI state
    @State private var selectedTimeLimitIndex = 0

    /// The time-limit buckets we currently support.
    private let timeLimits = [30, 60, 120, 300, 600]

    /// Scores filtered to the currently selected time-limit, sorted by date.
    private var filteredScores: [ScoreEntry] {
        store.scores
            .filter { $0.timeLimit == timeLimits[selectedTimeLimitIndex] }
            .sorted { $0.date < $1.date }
    }

    // MARK: – Body
    var body: some View {
        VStack(spacing: 24) {

            // ── Picker ──────────────────────────────────────
            Picker("Time Limit", selection: $selectedTimeLimitIndex) {
                ForEach(timeLimits.indices, id: \.self) { idx in
                    Text("\(timeLimits[idx]) s")
                        .tag(idx)
                }
            }
            .pickerStyle(.segmented)

            // ── Chart / empty state ─────────────────────────
            if filteredScores.isEmpty {
                ContentUnavailableView("No data yet for this time limit",
                                       systemImage: "chart.line.uptrend.xyaxis")
            } else {
                Chart(filteredScores) {
                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Score", $0.score)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.tint)          // adapts to dark / light

                    PointMark(
                        x: .value("Date", $0.date),
                        y: .value("Score", $0.score)
                    )
                    .symbolSize(40)
                }
                .frame(height: 300)
                .padding(.top, 8)
            }

            Spacer(minLength: 12)
        }
        .padding()
        .navigationTitle("Progress")
        .animation(.default, value: selectedTimeLimitIndex)
    }
}

// MARK: – Preview
#Preview {
    // Inject some mock data so the chart isn’t empty in previews.
    let mockStore = ScoreStore()
    mockStore.add(.init(id: .init(), date: .now.addingTimeInterval(-86400*4),
                        score: 5,  timeLimit: 60))
    mockStore.add(.init(id: .init(), date: .now.addingTimeInterval(-86400*2),
                        score: 8,  timeLimit: 60))
    mockStore.add(.init(id: .init(), date: .now,
                        score: 10, timeLimit: 60))

    return NavigationStack {
        ScoreGraphView()
            .environmentObject(mockStore)
    }
}
