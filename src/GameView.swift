import SwiftUI
import Combine

// MARK: – GameView
struct GameView: View {

    // MARK: Config passed from HomeView
    struct Config: Equatable {
        let timeLimit:               Int

        let lowerAddition:           Int
        let upperAddition:           Int
        let lowerSubtraction:        Int
        let upperSubtraction:        Int
        let lowerMultiplication:     Int
        let upperMultiplication:     Int
        let lowerDivision:           Int
        let upperDivision:           Int

        let enableAddition:          Bool
        let enableSubtraction:       Bool
        let enableMultiplication:    Bool
        let enableDivision:          Bool
    }

    // Injected on navigation
    let config: Config

    // MARK: – Environment
    @Environment(\.dismiss)         private var dismiss
    @EnvironmentObject              private var store: ScoreStore

    // MARK: – State
    @State private var timeLeft                       = 0
    @State private var score                          = 0
    @State private var currentQuestion                = ""
    @State private var correctAnswer                  = 0
    @State private var userAnswer                     = ""
    @State private var isGameOver                     = false
    @State private var isNewHighScore                 = false
    @State private var timerCancellable: AnyCancellable?

    @State private var highScores: [Int: Int] =
        (UserDefaults.standard.dictionary(forKey: "HighScores") as? [String: Int])?
        .reduce(into: [:]) { dict, pair in dict[Int(pair.key) ?? 0] = pair.value } ?? [:]

    // MARK: – View body
    var body: some View {
        VStack(spacing: 24) {

            headerView

            Spacer()

            if isGameOver {
                gameOverView
            } else {
                gameInProgressView
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(!isGameOver)   // block premature exit
        .onAppear(perform: startGameOnce)
        .onDisappear { timerCancellable?.cancel() }
    }

    // MARK: – Sub-views
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
                .keyboardType(.numberPad)          // number-only keyboard
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
        guard timerCancellable == nil else { return }     // ensure single start
        timeLeft = config.timeLimit
        score = 0
        isGameOver = false
        isNewHighScore = false
        generateQuestion()

        timerCancellable = Timer
            .publish(every: 1, on: .main, in: .common)
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
        // High-score update
        if score > highScores[config.timeLimit, default: 0] {
            highScores[config.timeLimit] = score
            let stringKeyed = highScores.reduce(into: [String: Int]()) { dict, pair in
                dict[String(pair.key)] = pair.value
            }
            UserDefaults.standard.set(stringKeyed, forKey: "HighScores")
            isNewHighScore = true
        }

        // Persist in score history
        store.add(ScoreEntry(id: .init(),
                             date: .now,
                             score: score,
                             timeLimit: config.timeLimit))

        isGameOver = true
    }

    // MARK: – Question generation & answer checking
    private func checkAnswer() {
        guard let typed = Int(userAnswer),
              typed == correctAnswer else { return }
        score += 1
        userAnswer = ""
        generateQuestion()
    }

    private func generateQuestion() {
        // Derive enabled operations
        var ops: [Operator] = []
        if config.enableAddition       { ops.append(.add) }
        if config.enableSubtraction    { ops.append(.sub) }
        if config.enableMultiplication { ops.append(.mul) }
        if config.enableDivision       { ops.append(.div) }

        guard let op = ops.randomElement() else {
            currentQuestion = "No operations enabled!"
            correctAnswer   = Int.min
            return
        }

        switch op {
        case .add:
            let a = Int.random(in: config.lowerAddition...config.upperAddition)
            let b = Int.random(in: config.lowerAddition...config.upperAddition)
            currentQuestion = "\(a) + \(b) = ?"
            correctAnswer   = a + b

        case .sub:
            var a = Int.random(in: config.lowerSubtraction...config.upperSubtraction)
            var b = Int.random(in: config.lowerSubtraction...config.upperSubtraction)
            if b > a { swap(&a, &b) }                      // keep answer ≥ 0
            currentQuestion = "\(a) − \(b) = ?"
            correctAnswer   = a - b

        case .mul:
            let a = Int.random(in: config.lowerMultiplication...config.upperMultiplication)
            let b = Int.random(in: config.lowerMultiplication...config.upperMultiplication)
            currentQuestion = "\(a) × \(b) = ?"
            correctAnswer   = a * b

        case .div:
            let divisor = Int.random(in: max(1, config.lowerDivision)...max(1, config.upperDivision))
            let quotient = Int.random(in: max(1, config.lowerDivision)...max(1, config.upperDivision))
            let dividend = divisor * quotient              // ensures whole-number answer
            currentQuestion = "\(dividend) ÷ \(divisor) = ?"
            correctAnswer   = quotient
        }
    }

    // MARK: – Helpers
    private enum Operator { case add, sub, mul, div }
}

// MARK: – Preview
#Preview {
    NavigationStack {
        GameView(config: .init(
            timeLimit: 30,
            lowerAddition: 1, upperAddition: 20,
            lowerSubtraction: 1, upperSubtraction: 20,
            lowerMultiplication: 1, upperMultiplication: 12,
            lowerDivision: 1, upperDivision: 12,
            enableAddition: true, enableSubtraction: true,
            enableMultiplication: true, enableDivision: true
        ))
        .environmentObject(ScoreStore())
    }
}
