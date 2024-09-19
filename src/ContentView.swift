import SwiftUI

struct ContentView: View {
    @AppStorage("additionEnabled") private var additionEnabled = true
    @AppStorage("subtractionEnabled") private var subtractionEnabled = true
    @AppStorage("multiplicationEnabled") private var multiplicationEnabled = true
    @AppStorage("divisionEnabled") private var divisionEnabled = true

    @AppStorage("lbaddition1") private var lbaddition1: String = "2"
    @AppStorage("ubaddition1") private var ubaddition1: String = "100"
    @AppStorage("lbaddition2") private var lbaddition2: String = "2"
    @AppStorage("ubaddition2") private var ubaddition2: String = "100"

    @AppStorage("lbsubtraction1") private var lbsubtraction1: String = "2"
    @AppStorage("ubsubtraction1") private var ubsubtraction1: String = "100"
    @AppStorage("lbsubtraction2") private var lbsubtraction2: String = "2"
    @AppStorage("ubsubtraction2") private var ubsubtraction2: String = "100"

    @AppStorage("lbmultiplication1") private var lbmultiplication1: String = "2"
    @AppStorage("ubmultiplication1") private var ubmultiplication1: String = "12"
    @AppStorage("lbmultiplication2") private var lbmultiplication2: String = "2"
    @AppStorage("ubmultiplication2") private var ubmultiplication2: String = "100"

    @AppStorage("lbdivision1") private var lbdivision1: String = "2"
    @AppStorage("ubdivision1") private var ubdivision1: String = "100"
    @AppStorage("lbdivision2") private var lbdivision2: String = "2"
    @AppStorage("ubdivision2") private var ubdivision2: String = "12"

    @AppStorage("timeLimit") private var timeLimit: Int = 120
    @AppStorage("isDarkMode") private var isDarkMode = false
    private var isAtLeastOneOperationEnabled: Bool {
        return additionEnabled || subtractionEnabled || multiplicationEnabled || divisionEnabled
    }
    
    private var numberOfOperationsEnabled: Int {
        [additionEnabled, subtractionEnabled, multiplicationEnabled, divisionEnabled].filter { $0 }.count
    }
//so that at least one operation is enabled at all times

    var body: some View {
        ScrollView {
            VStack(spacing: 11) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Toggle("Addition", isOn: Binding<Bool>(
                    get: { additionEnabled },
                    set: { newValue in
                        if newValue {
                            additionEnabled = true
                        } else if numberOfOperationsEnabled > 1 {
                            additionEnabled = false
                        }
                    }
                ))
                .font(.title2)
                .fontWeight(.bold)

                if additionEnabled {
                    VStack(alignment: .leading) {
                        Text("Range:")
                            .offset(y: -10)
                        HStack {
                            Text("(")
                            CustomTextField(text: $lbaddition1)
                            Text(" to ")
                            CustomTextField(text: $ubaddition1)
                            Text(")")
                            Text("+")
                                .font(.title2)
                            Text("(")
                            CustomTextField(text: $lbaddition2)
                            Text(" to ")
                            CustomTextField(text: $ubaddition2)
                            Text(")")
                        }
                        .offset(y: -10)
                    }
                }

                Toggle("Subtraction", isOn: Binding<Bool>(
                    get: { subtractionEnabled },
                    set: { newValue in
                        if newValue {
                            subtractionEnabled = true
                        } else if numberOfOperationsEnabled > 1 {
                            subtractionEnabled = false
                        }
                    }
                ))
                .font(.title2)
                .fontWeight(.bold)


                if subtractionEnabled {
                    VStack(alignment: .leading) {
                        Text("Range:")
                            .offset(y: -10)
                        HStack {
                            Text("(")
                            CustomTextField(text: $lbsubtraction1)
                            Text(" to ")
                            CustomTextField(text: $ubsubtraction1)
                            Text(")")
                            Text("-")
                                .font(.title2)
                            Text("(")
                            CustomTextField(text: $lbsubtraction2)
                            Text(" to ")
                            CustomTextField(text: $ubsubtraction2)
                            Text(")")
                        }
                        .offset(y: -10)
                    }
                }

                Toggle("Multiplication", isOn: Binding<Bool>(
                    get: { multiplicationEnabled },
                    set: { newValue in
                        if newValue {
                            multiplicationEnabled = true
                        } else if numberOfOperationsEnabled > 1 {
                            multiplicationEnabled = false
                        }
                    }
                ))
                .font(.title2)
                .fontWeight(.bold)


                if multiplicationEnabled {
                    VStack(alignment: .leading) {
                        Text("Range:")
                            .offset(y: -10)
                        HStack {
                            Text("(")
                            CustomTextField(text: $lbmultiplication1)
                            Text(" to ")
                            CustomTextField(text: $ubmultiplication1)
                            Text(")")
                            Text("*")
                                .font(.title2)
                            Text("(")
                            CustomTextField(text: $lbmultiplication2)
                            Text(" to ")
                            CustomTextField(text: $ubmultiplication2)
                            Text(")")
                        }
                        .offset(y: -10)
                    }
                }

                Toggle("Division", isOn: Binding<Bool>(
                    get: { divisionEnabled },
                    set: { newValue in
                        if newValue {
                            divisionEnabled = true
                        } else if numberOfOperationsEnabled > 1 {
                            divisionEnabled = false
                        }
                    }
                ))
                .font(.title2)
                .fontWeight(.bold)

                if divisionEnabled {
                    VStack(alignment: .leading) {
                        Text("Range:")
                            .offset(y: -10)
                        HStack {
                            Text("(")
                            CustomTextField(text: $lbdivision1)
                            Text(" to ")
                            CustomTextField(text: $ubdivision1)
                            Text(")")
                            Text("/")
                                .font(.title2)
                            Text("(")
                            CustomTextField(text: $lbdivision2)
                            Text(" to ")
                            CustomTextField(text: $ubdivision2)
                            Text(")")
                        }
                        .offset(y: -10)
                    }
                }

                // Time Limit Picker
                Picker("Time Limit", selection: $timeLimit) {
                    Text("30 seconds").tag(30)
                    Text("60 seconds").tag(60)
                    Text("120 seconds").tag(120)
                    Text("300 seconds").tag(300)
                    Text("600 seconds").tag(600)
                }
                .pickerStyle(MenuPickerStyle())

                Spacer()

                // Dark mode toggle
                Button(action: {
                    self.isDarkMode.toggle()
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title)
                        .foregroundColor(isDarkMode ? .white : .primary)
                }
                .offset(y: -6)

                Spacer()
            }
            .padding()

        }
    }

    func validateRanges() -> Bool {
        return Int(lbaddition1) ?? 2 <= Int(ubaddition1) ?? 100 &&
               Int(lbaddition2) ?? 2 <= Int(ubaddition2) ?? 100 &&
               Int(lbsubtraction1) ?? 2 <= Int(ubsubtraction1) ?? 100 &&
               Int(lbsubtraction2) ?? 2 <= Int(ubsubtraction2) ?? 100 &&
               Int(lbmultiplication1) ?? 2 <= Int(ubmultiplication1) ?? 12 &&
               Int(lbmultiplication2) ?? 2 <= Int(ubmultiplication2) ?? 100 &&
               Int(lbdivision1) ?? 2 <= Int(ubdivision1) ?? 100 &&
               Int(lbdivision2) ?? 2 <= Int(ubdivision2) ?? 12
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
