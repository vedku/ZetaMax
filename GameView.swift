//
//  GameView.swift
//  ZetaMax
//
//  Created by Ved Kuwadekar on 03/09/2024.
//

import SwiftUI

struct GameView: View {
    let timeLimit: Int
    let additionEnabled: Bool
    let subtractionEnabled: Bool
    let multiplicationEnabled: Bool
    let divisionEnabled: Bool
    
    let additionLowerBound1: Int
    let additionUpperBound1: Int
    let additionLowerBound2: Int
    let additionUpperBound2: Int
    let subtractionLowerBound1: Int
    let subtractionUpperBound1: Int
    let subtractionLowerBound2: Int
    let subtractionUpperBound2: Int
    let multiplicationLowerBound1: Int
    let multiplicationUpperBound1: Int
    let multiplicationLowerBound2: Int
    let multiplicationUpperBound2: Int
    let divisionLowerBound1: Int
    let divisionUpperBound1: Int
    let divisionLowerBound2: Int
    let divisionUpperBound2: Int
    
    @State private var timeLeft: Int
    @State private var score: Int = 0
    @State private var currentQuestion: String = ""
    @State private var correctAnswer: Int = 0
    @State private var userAnswer: String = ""
    @State private var timer: Timer?
    @State private var isGameOver: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var isNewHighScore: Bool = false
    
    init(timeLimit: Int, additionEnabled: Bool, subtractionEnabled: Bool, multiplicationEnabled: Bool, divisionEnabled: Bool, additionLowerBound1: Int, additionUpperBound1: Int, additionLowerBound2: Int, additionUpperBound2: Int, subtractionLowerBound1: Int, subtractionUpperBound1: Int, subtractionLowerBound2: Int, subtractionUpperBound2: Int, multiplicationLowerBound1: Int, multiplicationUpperBound1: Int, multiplicationLowerBound2: Int, multiplicationUpperBound2: Int, divisionLowerBound1: Int, divisionUpperBound1: Int, divisionLowerBound2: Int, divisionUpperBound2: Int) {
        self.timeLimit = timeLimit
        self.additionEnabled = additionEnabled
        self.subtractionEnabled = subtractionEnabled
        self.multiplicationEnabled = multiplicationEnabled
        self.divisionEnabled = divisionEnabled
        self.additionLowerBound1 = additionLowerBound1
        self.additionUpperBound1 = additionUpperBound1
        self.additionLowerBound2 = additionLowerBound2
        self.additionUpperBound2 = additionUpperBound2
        self.subtractionLowerBound1 = subtractionLowerBound1
        self.subtractionUpperBound1 = subtractionUpperBound1
        self.subtractionLowerBound2 = subtractionLowerBound2
        self.subtractionUpperBound2 = subtractionUpperBound2
        self.multiplicationLowerBound1 = multiplicationLowerBound1
        self.multiplicationUpperBound1 = multiplicationUpperBound1
        self.multiplicationLowerBound2 = multiplicationLowerBound2
        self.multiplicationUpperBound2 = multiplicationUpperBound2
        self.divisionLowerBound1 = divisionLowerBound1
        self.divisionUpperBound1 = divisionUpperBound1
        self.divisionLowerBound2 = divisionLowerBound2
        self.divisionUpperBound2 = divisionUpperBound2
        _timeLeft = State(initialValue: timeLimit)
    }
    
    var body: some View {
        VStack {
            if isGameOver {
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if isNewHighScore {
                    Text("New Best: \(highScore)")
                        .foregroundColor(.green)
                        .padding(.top, -10)
                } else {
                    Text("Best: \(highScore)")
                        .foregroundColor(.gray)
                        .padding(.top, -10)
                }
                
                VStack(spacing: 20) {
                    Button("Try Again") {
                        restartGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Change Settings") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                HStack {
                    Text("Seconds left: \(timeLeft)")
                        .font(.headline)
                        .onAppear(perform: startGame)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("Best: \(highScore)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Score: \(score)")
                            .font(.headline)
                    }
                }
                .padding([.leading, .trailing, .top])
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text(currentQuestion)
                        .font(.largeTitle)
                    
                    TextField("Answer", text: $userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onChange(of: userAnswer) {
                            checkAnswer()
                        }
                }
                
                Spacer()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startGame() {
        generateQuestion()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeLeft > 0 {
                self.timeLeft -= 1
            } else {
                self.timer?.invalidate()
                endGame()
            }
        }
    }
    
    func generateQuestion() {
        let operation = selectOperation()
        
        var random1: Int
        var random2: Int
        
        switch operation {
        case "+":
            random1 = Int.random(in: additionLowerBound1...additionUpperBound1)
            random2 = Int.random(in: additionLowerBound2...additionUpperBound2)
            currentQuestion = "\(random1) + \(random2) = ?"
            correctAnswer = random1 + random2
        case "-":
            random1 = Int.random(in: subtractionLowerBound1...subtractionUpperBound1)
            random2 = Int.random(in: subtractionLowerBound2...subtractionUpperBound2)
            currentQuestion = "\(random1 + random2) - \(random2) = ?"
            correctAnswer = random1
        case "*":
            random1 = Int.random(in: multiplicationLowerBound1...multiplicationUpperBound2)
            random2 = Int.random(in: multiplicationLowerBound2...multiplicationUpperBound1)
            currentQuestion = "\(random1) * \(random2) = ?"
            correctAnswer = random1 * random2
        case "/":
            repeat {
                random1 = Int.random(in: divisionLowerBound1...divisionUpperBound1)
                random2 = Int.random(in: divisionLowerBound2...divisionUpperBound2)
            } while random2 == 0 || random1 % random2 != 0
            currentQuestion = "\(random1) / \(random2) = ?"
            correctAnswer = random1 / random2
        default:
            break
        }
        
        userAnswer = ""
    }
    
    func checkAnswer() {
        if let answer = Int(userAnswer), answer == correctAnswer {
            score += 1
            generateQuestion()
        } else if userAnswer.count >= correctAnswer.description.count {
            userAnswer = ""
        }
    }
    
    func selectOperation() -> String {
        var operations = [String]()
        if additionEnabled { operations.append("+") }
        if subtractionEnabled { operations.append("-") }
        if multiplicationEnabled { operations.append("*") }
        if divisionEnabled { operations.append("/") }
        return operations.randomElement() ?? "+"
    }
    
    func endGame() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
            isNewHighScore = true
        } else {
            isNewHighScore = false
        }
                var scores = UserDefaults.standard.array(forKey: "Scores") as? [[String: Any]] ?? []
        scores.append(["date": Date(), "score": score])
        UserDefaults.standard.set(scores, forKey: "Scores")
        
        isGameOver = true
    }

    func restartGame() {
        score = 0
        timeLeft = timeLimit
        isGameOver = false
        isNewHighScore = false
        startGame()
    }
}

struct CustomTextField: View {
    @Binding var text: String
    var borderColor: Color = .gray
    
    var body: some View {
        TextField("", text: $text)
            .padding(4)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(5)
            .frame(height: 27)
            .frame(width: 50)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            )
            .keyboardType(.numberPad)
    }
}

struct GameView_previews: PreviewProvider {
    static var previews: some View {
        GameView(
            timeLimit: 60,
            additionEnabled: true,
            subtractionEnabled: false,
            multiplicationEnabled: true,
            divisionEnabled: false,
            additionLowerBound1: 2,
            additionUpperBound1: 100,
            additionLowerBound2: 2,
            additionUpperBound2: 100,
            subtractionLowerBound1: 2,
            subtractionUpperBound1: 100,
            subtractionLowerBound2: 2,
            subtractionUpperBound2: 100,
            multiplicationLowerBound1: 2,
            multiplicationUpperBound1: 12,
            multiplicationLowerBound2: 2,
            multiplicationUpperBound2: 100,
            divisionLowerBound1: 2,
            divisionUpperBound1: 100,
            divisionLowerBound2: 2,
            divisionUpperBound2: 12
        )
    }
}

