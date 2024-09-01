import SwiftUI

struct ContentView: View {
    @State private var additionEnabled = true
    @State private var subtractionEnabled = true
    @State private var multiplicationEnabled = true
    @State private var divisionEnabled = true
    
    @State private var lbaddition1: String = "2"
    @State private var ubaddition1: String = "100"
    @State private var lbaddition2: String = "2"
    @State private var ubaddition2: String = "100"
    @State private var multiplicationRange1: String = "2"
    @State private var multiplicationRange2: String = "12"
    @State private var multiplicationRange3: String = "2"
    @State private var multiplicationRange4: String = "100"
    
    @State private var timeLimit = 120
    @State private var isGameActive = false
    
    private var isAtLeastOneOperationEnabled: Bool {
        return additionEnabled || subtractionEnabled || multiplicationEnabled || divisionEnabled
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("ZetaMax")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Toggle("Addition", isOn: $additionEnabled)
                        .font(.title2)
                        .fontWeight(.bold)
                    if additionEnabled {
                        VStack(alignment: .leading) {
                            
                            Text("Range:")
                                .offset(y:-10)
                            HStack {
                                Text("(")
                                TextField("2", text: $lbaddition1)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("100", text: $ubaddition1)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(") + (")
                                TextField("2", text: $lbaddition2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("100", text: $ubaddition2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(")")
                            }
                            .offset(y:-10)
                        }
                    }
                                        
                    HStack {
                        Text("Subtraction ")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("(same range as addition)")
                            .font(.subheadline)

                        Toggle("", isOn: $subtractionEnabled)
                            .labelsHidden()
                            .padding(.leading, 10)
                    }
                    
                
                    
                    Toggle("Multiplication", isOn: $multiplicationEnabled)
                        .font(.title3)
                        .fontWeight(.bold)
                    if multiplicationEnabled {
                        VStack(alignment: .leading) {
                            Text("Range:")
                                .offset(y:-10)

                            HStack {
                                Text("(")
                                TextField("2", text: $multiplicationRange1)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("12", text: $multiplicationRange2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(") × (")
                                TextField("2", text: $multiplicationRange3)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("100", text: $multiplicationRange4)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(")")
                            }
                            .offset(y:-10)

                        }
                    }
                    
                    HStack {
                        Text("Division ")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("(same range as multiplication)")
                            .font(.subheadline)

                        Toggle("", isOn: $divisionEnabled)
                            .labelsHidden()
                            .padding(.leading, 10)
                    }
                    .offset(y:-4)
                    
                    Spacer()
                    Picker("Duration", selection: $timeLimit) {
                        Text("30 seconds").tag(30)
                        Text("60 seconds").tag(60)
                        Text("120 seconds").tag(120)
                        Text("300 seconds").tag(300)
                        Text("600 seconds").tag(600)
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer()
                    Button("Start") {
                        // Validate ranges before starting the game
                        guard validateRanges() else {
                            // Show an alert or handle invalid ranges
                            return
                        }
                        isGameActive = true
                    }
                    .padding()
                    .background(isAtLeastOneOperationEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!isAtLeastOneOperationEnabled)
                    .navigationDestination(isPresented: $isGameActive) {
                        GameView(
                            timeLimit: timeLimit,
                            additionEnabled: additionEnabled,
                            subtractionEnabled: subtractionEnabled,
                            multiplicationEnabled: multiplicationEnabled,
                            divisionEnabled: divisionEnabled,
                            additionLowerBound1: Int(lbaddition1) ?? 2,
                            additionUpperBound1: Int(ubaddition1) ?? 100,
                            additionLowerBound2: Int(lbaddition2) ?? 2,
                            additionUpperBound2: Int(ubaddition2) ?? 100,
                            multiplicationLowerBound1: Int(multiplicationRange1) ?? 2,
                            multiplicationUpperBound2: Int(multiplicationRange2) ?? 12,
                            multiplicationLowerBound3: Int(multiplicationRange3) ?? 2,
                            multiplicationUpperBound4: Int(multiplicationRange4) ?? 100
                        )
                    }
                }
                .padding()
            }
        }
    }
    
    func validateRanges() -> Bool {
        return Int(lbaddition1) ?? 2 <= Int(ubaddition1) ?? 100 &&
               Int(lbaddition2) ?? 2 <= Int(ubaddition2) ?? 100 &&
               Int(multiplicationRange1) ?? 2 <= Int(multiplicationRange2) ?? 12 &&
               Int(multiplicationRange3) ?? 2 <= Int(multiplicationRange4) ?? 100
    }
}

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
    let multiplicationLowerBound1: Int
    let multiplicationUpperBound2: Int
    let multiplicationLowerBound3: Int
    let multiplicationUpperBound4: Int
    
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
    
    init(timeLimit: Int, additionEnabled: Bool, subtractionEnabled: Bool, multiplicationEnabled: Bool, divisionEnabled: Bool, additionLowerBound1: Int, additionUpperBound1: Int, additionLowerBound2: Int, additionUpperBound2: Int, multiplicationLowerBound1: Int, multiplicationUpperBound2: Int, multiplicationLowerBound3: Int, multiplicationUpperBound4: Int) {
        self.timeLimit = timeLimit
        self.additionEnabled = additionEnabled
        self.subtractionEnabled = subtractionEnabled
        self.multiplicationEnabled = multiplicationEnabled
        self.divisionEnabled = divisionEnabled
        self.additionLowerBound1 = additionLowerBound1
        self.additionUpperBound1 = additionUpperBound1
        self.additionLowerBound2 = additionLowerBound2
        self.additionUpperBound2 = additionUpperBound2
        self.multiplicationLowerBound1 = multiplicationLowerBound1
        self.multiplicationUpperBound2 = multiplicationUpperBound2
        self.multiplicationLowerBound3 = multiplicationLowerBound3
        self.multiplicationUpperBound4 = multiplicationUpperBound4
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
            random1 = Int.random(in: additionLowerBound1...additionUpperBound1)
            random2 = Int.random(in: additionLowerBound2...additionUpperBound2)
            currentQuestion = "\(random1 + random2) - \(random2) = ?"
            correctAnswer = random1
        case "*":
            random1 = Int.random(in: multiplicationLowerBound1...multiplicationUpperBound4)
            random2 = Int.random(in: multiplicationLowerBound3...multiplicationUpperBound2)
            currentQuestion = "\(random1) * \(random2) = ?"
            correctAnswer = random1 * random2
        case "/":
            repeat {
                random1 = Int.random(in: multiplicationLowerBound1...multiplicationUpperBound4)
                random2 = Int.random(in: multiplicationLowerBound3...multiplicationUpperBound2)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
