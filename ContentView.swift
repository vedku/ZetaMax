import SwiftUI

struct ContentView: View {
    @Binding var additionEnabled: Bool
    @Binding var subtractionEnabled: Bool
    @Binding var multiplicationEnabled: Bool
    @Binding var divisionEnabled: Bool
    
    @Binding var lbaddition1: String
    @Binding var ubaddition1: String
    @Binding var lbaddition2: String
    @Binding var ubaddition2: String
    
    @Binding var lbsubtraction1: String
    @Binding var ubsubtraction1: String
    @Binding var lbsubtraction2: String
    @Binding var ubsubtraction2: String
    
    @Binding var lbmultiplication1: String
    @Binding var ubmultiplication1: String
    @Binding var lbmultiplication2: String
    @Binding var ubmultiplication2: String
    
    @Binding var lbdivision1: String
    @Binding var ubdivision1: String
    @Binding var lbdivision2: String
    @Binding var ubdivision2: String
    
    @Binding var timeLimit: Int
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private var isAtLeastOneOperationEnabled: Bool {
        return additionEnabled || subtractionEnabled || multiplicationEnabled || divisionEnabled
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 11) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Toggle("Addition", isOn: $additionEnabled)
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
                
                Toggle("Subtraction", isOn: $subtractionEnabled)
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
                
                Toggle("Multiplication", isOn: $multiplicationEnabled)
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
                            Text("×")
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
                
                Toggle("Division", isOn: $divisionEnabled)
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
                            Text("÷")
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
                
                Picker("Duration", selection: $timeLimit) {
                    Text("30 seconds").tag(30)
                    Text("60 seconds").tag(60)
                    Text("120 seconds").tag(120)
                    Text("300 seconds").tag(300)
                    Text("600 seconds").tag(600)
                }
                .pickerStyle(MenuPickerStyle())

                Spacer()

                Button(action: {
                    self.isDarkMode.toggle()
                }) {
                    Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title)
                        .foregroundColor(isDarkMode ? .white : .primary)
                }.offset(y: -6)
                
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
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





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            additionEnabled: .constant(true),
            subtractionEnabled: .constant(false),
            multiplicationEnabled: .constant(true),
            divisionEnabled: .constant(false),
            lbaddition1: .constant("2"),
            ubaddition1: .constant("100"),
            lbaddition2: .constant("2"),
            ubaddition2: .constant("100"),
            lbsubtraction1: .constant("2"),
            ubsubtraction1: .constant("100"),
            lbsubtraction2: .constant("2"),
            ubsubtraction2: .constant("100"),
            lbmultiplication1: .constant("2"),
            ubmultiplication1: .constant("12"),
            lbmultiplication2: .constant("2"),
            ubmultiplication2: .constant("100"),
            lbdivision1: .constant("2"),
            ubdivision1: .constant("100"),
            lbdivision2: .constant("2"),
            ubdivision2: .constant("12"),
            timeLimit: .constant(60)
        )
    }
}
