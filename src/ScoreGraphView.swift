import SwiftUI
import Charts

struct ScoreEntry: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
    let timeLimit: Int
}

struct ScoreGraphView: View {
    @State private var scores: [ScoreEntry] = []
    @State private var selectedTimeLimitIndex: Int = 0
    private let timeLimits = [30, 60, 120, 300, 600]

    var body: some View {
        VStack {
            // Navigation Buttons
            HStack {
                Button(action: {
                    if selectedTimeLimitIndex > 0 {
                        selectedTimeLimitIndex -= 1
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                }
                Spacer()
                Text("Time Limit: \(timeLimits[selectedTimeLimitIndex]) seconds")
                    .font(.headline)
                Spacer()
                Button(action: {
                    if selectedTimeLimitIndex < timeLimits.count - 1 {
                        selectedTimeLimitIndex += 1
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title)
                }
            }
            .padding()

            // Filtered Scores for Selected Time Limit
            let filteredScores = scores.filter { $0.timeLimit == timeLimits[selectedTimeLimitIndex] }

            if filteredScores.isEmpty {
                Text("No data available for this time limit.")
                    .font(.headline)
                    .padding()
            } else {
                // Display Graph
                Chart {
                    ForEach(filteredScores) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Score", entry.score)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .frame(height: 300)
            }

            Spacer()
        }
        .onAppear {
            loadScores()
        }
    }

    // Load Scores from UserDefaults
    private func loadScores() {
        if let savedScores = UserDefaults.standard.array(forKey: "Scores") as? [[String: Any]] {
            scores = savedScores.compactMap { dict in
                if let date = dict["date"] as? Date,
                   let score = dict["score"] as? Int,
                   let timeLimit = dict["timeLimit"] as? Int {
                    return ScoreEntry(date: date, score: score, timeLimit: timeLimit)
                }
                return nil
            }
        }
    }
}



struct ScoreGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreGraphView()
    }
}
