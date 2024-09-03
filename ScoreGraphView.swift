import SwiftUI
import Charts

struct ScoreGraphView: View {
    @State private var scores: [(date: Date, score: Int)] = []

    var body: some View {
        VStack {
            if scores.isEmpty {
                Text("No data available.")
                    .font(.headline)
                    .padding()
            } else {
                Chart {
                    ForEach(scores, id: \.date) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Score", entry.score)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .frame(height: 300)
            }
        }
        .onAppear {
            loadScores()
        }
    }

    private func loadScores() {
        if let savedScores = UserDefaults.standard.array(forKey: "Scores") as? [[String: Any]] {
            scores = savedScores.compactMap { dict in
                if let date = dict["date"] as? Date, let score = dict["score"] as? Int {
                    return (date: date, score: score)
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
