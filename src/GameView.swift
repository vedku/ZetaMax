import SwiftUI
import Combine

// MARK: – GameView
/// The main quiz screen. Generates questions using the exact bounds / toggles
/// the user picked in **HomeView** and times the round.
struct GameView: View {

    // MARK: – Configuration coming from HomeView
    struct Config: Equatable {
        let timeLimit: Int

        // Separate ranges for each operand of each operation
        let lowerAddition1: Int
        let upperAddition1: Int
        let lowerAddition2: Int
        let upperAddition2: Int
        
        let lowerSubtraction1: Int
        let upperSubtraction1: Int
        let lowerSubtraction2: Int
        let upperSubtraction2: Int
        
        let lowerMultiplication1: Int
        let upperMultiplication1: Int
        let lowerMultiplication2: Int
        let upperMultiplication2: Int
        
        let lowerDivision1: Int
        let upperDivision1: Int
        let lowerDivision2: Int
        let upperDivision2: Int

        let enableAddition: Bool
        let enableSubtraction: Bool
        let enableMultiplication: Bool
        let enableDivision: Bool
    }

    // Injected when we navigate from HomeView → GameView.
    let config: Config

    // MARK: – Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: ScoreStore

    // MARK: – Game‑state
    @State private var timeLeft = 0
    @State private var score = 0

    @State private var currentQuestion = ""
    @State private var correctAnswer = 0
    @State private var userAnswer = ""

    @State private var isGameOver = false
    @State private var isNewHighScore = false
    @State private var timerCancellable: AnyCancellable?

    // Persisted best scores per time‑limit (keyed by seconds)
    @State private var highScores: [Int: Int] =
        (UserDefaults.standard.dictionary(forKey: "HighScores") as? [String: Int])?
        .reduce(into: [:]) { dict, pair in dict[Int(pair.key) ?? 0] = pair.value } ?? [:]

    // MARK: – Body
    var body: some View {
        VStack(spacing: 24) {
            headerView
            Spacer()
            if isGameOver { gameOverView } else { gameInProgressView }
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(!isGameOver)   // prevent rage‑quits mid‑round 😉
        .onAppear(perform: startGameOnce)
        .onDisappear { timerCancellable?.cancel() }
    }

    // MARK: – Sub‑views
    private var headerView: some View {
        HStack {
            Text("⏱ \(timeLeft)s")
            Spacer()
            VStack(alignment: .trailing) {
                Text("Best: \(highScores[config.timeLimit, default: 0])")
                Text("Score: \(score)")
            }
        }
        .font(.headline)
    }

    private var gameInProgressView: some View {
        VStack(spacing: 32) {
            Text(currentQuestion)
                .font(.largeTitle.bold())
                .minimumScaleFactor(0.5)

            TextField("Answer", text: $userAnswer)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)              // 👉 pure number keyboard
                .multilineTextAlignment(.center)
                .onChange(of: userAnswer) {
                    checkAnswer()
                }
                .submitLabel(.done)
                .onSubmit(checkAnswer)
        }
        .frame(maxWidth: .infinity)
    }

    private var gameOverView: some View {
        VStack(spacing: 32) {
            Text("Final Score \(score)")
                .font(.largeTitle.bold())

            Text(isNewHighScore ? "🎉 New High Score!" :
                 "Best: \(highScores[config.timeLimit, default: 0])")
                .font(.title3.weight(.medium))
                .foregroundStyle(isNewHighScore ? .green : .secondary)

            Button("Play Again", action: restartGame)
                .buttonStyle(.borderedProminent)

            Button("Back to Menu", role: .cancel) { dismiss() }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: – Game lifecycle
    private func startGameOnce() {
        guard timerCancellable == nil else { return }           // only start once
        timeLeft = config.timeLimit
        score = 0
        isGameOver = false
        isNewHighScore = false
        generateQuestion()

        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                timeLeft -= 1
                if timeLeft == 0 {
                    timerCancellable?.cancel()
                    endGame()
                }
            }
    }

    private func restartGame() {
        userAnswer = ""
        timerCancellable?.cancel()
        startGameOnce()
    }

    private func endGame() {
        // Update high‑score
        if score > highScores[config.timeLimit, default: 0] {
            highScores[config.timeLimit] = score
            let stringKeyed = highScores.reduce(into: [String: Int]()) { dict, pair in
                dict[String(pair.key)] = pair.value
            }
            UserDefaults.standard.set(stringKeyed, forKey: "HighScores")
            isNewHighScore = true
        }

        // Persist in history
        store.add(ScoreEntry(id: .init(), date: .now, score: score, timeLimit: config.timeLimit))
        isGameOver = true
    }

    // MARK: – Question generation / checking
    private func checkAnswer() {
        guard let typed = Int(userAnswer), typed == correctAnswer else { return }
        score += 1
        userAnswer = ""
        generateQuestion()
    }

    private func generateQuestion() {
        // Figure out which operators are enabled
        var ops: [Operator] = []
        if config.enableAddition { ops.append(.add) }
        if config.enableSubtraction { ops.append(.sub) }
        if config.enableMultiplication { ops.append(.mul) }
        if config.enableDivision { ops.append(.div) }

        guard let op = ops.randomElement() else {
            currentQuestion = "No operations enabled!"
            correctAnswer = Int.min
            return
        }

        switch op {
        case .add:
            let a = Int.random(in: config.lowerAddition1...config.upperAddition1)
            let b = Int.random(in: config.lowerAddition2...config.upperAddition2)
            currentQuestion = "\(a) + \(b) = ?"
            correctAnswer = a + b

        case .sub:
            var a = Int.random(in: config.lowerSubtraction1...config.upperSubtraction1)
            var b = Int.random(in: config.lowerSubtraction2...config.upperSubtraction2)
            if b > a { swap(&a, &b) }                  // keep non‑negative answer
            currentQuestion = "\(a) − \(b) = ?"
            correctAnswer = a - b

        case .mul:
            let a = Int.random(in: config.lowerMultiplication1...config.upperMultiplication1)
            let b = Int.random(in: config.lowerMultiplication2...config.upperMultiplication2)
            currentQuestion = "\(a) × \(b) = ?"
            correctAnswer = a * b

        case .div:
            let divisor = Int.random(in: max(1, config.lowerDivision2)...max(1, config.upperDivision2))
            let quotient = Int.random(in: max(1, config.lowerDivision1)...max(1, config.upperDivision1))
            let dividend = divisor * quotient          // ensures whole‑number answer
            currentQuestion = "\(dividend) ÷ \(divisor) = ?"
            correctAnswer = quotient
        }
    }

    // MARK: – Internal helpers
    private enum Operator { case add, sub, mul, div }
}

// MARK: – Preview
#Preview {
    NavigationStack {
        GameView(config: .init(
            timeLimit: 30,
            lowerAddition1: 1, upperAddition1: 20,
            lowerAddition2: 1, upperAddition2: 20,
            lowerSubtraction1: 1, upperSubtraction1: 20,
            lowerSubtraction2: 1, upperSubtraction2: 20,
            lowerMultiplication1: 1, upperMultiplication1: 12,
            lowerMultiplication2: 1, upperMultiplication2: 12,
            lowerDivision1: 1, upperDivision1: 12,
            lowerDivision2: 1, upperDivision2: 12,
            enableAddition: true, enableSubtraction: true,
            enableMultiplication: true, enableDivision: true
        ))
        .environmentObject(ScoreStore())
    }
}
