import SwiftUI

struct ContentView: View {
    @State private var additionEnabled = true
    @State private var subtractionEnabled = true
    @State private var multiplicationEnabled = true
    @State private var divisionEnabled = true
    
    // Ranges for the operations
    @State private var additionRange1: String = "2"
    @State private var additionRange2: String = "100"
    @State private var multiplicationRange1: String = "2"
    @State private var multiplicationRange2: String = "12"
    @State private var multiplicationRange3: String = "2"
    @State private var multiplicationRange4: String = "100"
    
    @State private var timeLimit = 120
    @State private var isGameActive = false
    
    // Computed property to check if at least one operation is enabled
    private var isAtLeastOneOperationEnabled: Bool {
        return additionEnabled || subtractionEnabled || multiplicationEnabled || divisionEnabled
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Arithmetic Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Toggle("Addition", isOn: $additionEnabled)
                    if additionEnabled {
                        VStack(alignment: .leading) {
                            Text("Range:")
                            HStack {
                                Text("(")
                                TextField("2", text: $additionRange1)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("100", text: $additionRange2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(") + (")
                                TextField("2", text: $additionRange1)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(" to ")
                                TextField("100", text: $additionRange2)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .frame(width: 50)
                                Text(")")
                            }
                        }
                    }
                    
                    Toggle("Subtraction (same range as Addition)", isOn: $subtractionEnabled)
                    
                    Toggle("Multiplication", isOn: $multiplicationEnabled)
                    if multiplicationEnabled {
                        VStack(alignment: .leading) {
                            Text("Range:")
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
                        }
                    }
                    
                    Toggle("Division (same range as Multiplication)", isOn: $divisionEnabled)
                    
                    Picker("Duration", selection: $timeLimit) {
                        Text("30 seconds").tag(30)
                        Text("60 seconds").tag(60)
                        Text("120 seconds").tag(120)
                        Text("300 seconds").tag(300)
                        Text("600 seconds").tag(600)
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Button("Start") {
                        isGameActive = true
                    }
                    .padding()
                    .background(isAtLeastOneOperationEnabled ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(!isAtLeastOneOperationEnabled)
                    .navigationDestination(isPresented: $isGameActive) {
                        GameView(timeLimit: timeLimit, additionEnabled: additionEnabled, subtractionEnabled: subtractionEnabled, multiplicationEnabled: multiplicationEnabled, divisionEnabled: divisionEnabled)
                    }
                }
                .padding()
            }
        }
    }
}



struct GameView: View {
    let timeLimit: Int
    let additionEnabled: Bool
    let subtractionEnabled: Bool
    let multiplicationEnabled: Bool
    let divisionEnabled: Bool
    
    @State private var timeLeft: Int
    @State private var score: Int = 0
    @State private var currentQuestion: String = ""
    @State private var correctAnswer: Int = 0
    @State private var userAnswer: String = ""
    @State private var timer: Timer?
    @State private var isGameOver: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(timeLimit: Int, additionEnabled: Bool, subtractionEnabled: Bool, multiplicationEnabled: Bool, divisionEnabled: Bool) {
        self.timeLimit = timeLimit
        self.additionEnabled = additionEnabled
        self.subtractionEnabled = subtractionEnabled
        self.multiplicationEnabled = multiplicationEnabled
        self.divisionEnabled = divisionEnabled
        _timeLeft = State(initialValue: timeLimit)
    }
    
    var body: some View {
        VStack {
            if isGameOver {
                // Game over view
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
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
                // Game in progress view
                HStack {
                    Text("Seconds left: \(timeLeft)")
                        .font(.headline)
                        .onAppear(perform: startGame)
                    
                    Spacer()
                    
                    Text("Score: \(score)")
                        .font(.headline)
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
        
        let random1 = Int.random(in: 2...100)
        let random2 = operation == "*" || operation == "/" ? Int.random(in: 2...12) : Int.random(in: 2...100)
        
        switch operation {
        case "+":
            currentQuestion = "\(random1) + \(random2) = ?"
            correctAnswer = random1 + random2
        case "-":
            currentQuestion = "\(random1 + random2) - \(random2) = ?"
            correctAnswer = random1
        case "*":
            currentQuestion = "\(random1) * \(random2) = ?"
            correctAnswer = random1 * random2
        case "/":
            currentQuestion = "\(random1 * random2) / \(random2) = ?"
            correctAnswer = random1
        default:
            break
        }
        userAnswer = ""
    }
    
    func checkAnswer() {
        if let answer = Int(userAnswer), answer == correctAnswer {
            score += 1
            generateQuestion()
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
        isGameOver = true
    }
    
    func restartGame() {
        score = 0
        timeLeft = timeLimit
        isGameOver = false
        startGame()
    }
}





struct ZetamacCloneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
