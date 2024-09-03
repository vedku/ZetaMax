import SwiftUI

struct HomeView: View {
    @State private var additionEnabled = true
    @State private var subtractionEnabled = true
    @State private var multiplicationEnabled = true
    @State private var divisionEnabled = true
    
    @State private var lbaddition1: String = "2"
    @State private var ubaddition1: String = "100"
    @State private var lbaddition2: String = "2"
    @State private var ubaddition2: String = "100"
    
    @State private var lbsubtraction1: String = "2"
    @State private var ubsubtraction1: String = "100"
    @State private var lbsubtraction2: String = "2"
    @State private var ubsubtraction2: String = "100"
    
    @State private var lbmultiplication1: String = "2"
    @State private var ubmultiplication1: String = "12"
    @State private var lbmultiplication2: String = "2"
    @State private var ubmultiplication2: String = "100"
    
    @State private var lbdivision1: String = "2"
    @State private var ubdivision1: String = "100"
    @State private var lbdivision2: String = "2"
    @State private var ubdivision2: String = "12"
    
    @State private var timeLimit = 120
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("ZetaMax")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: GameView(
                    timeLimit: timeLimit,
                    additionEnabled: additionEnabled,
                    subtractionEnabled: subtractionEnabled,
                    multiplicationEnabled: multiplicationEnabled,
                    divisionEnabled: divisionEnabled,
                    additionLowerBound1: Int(lbaddition1) ?? 2,
                    additionUpperBound1: Int(ubaddition1) ?? 100,
                    additionLowerBound2: Int(lbaddition2) ?? 2,
                    additionUpperBound2: Int(ubaddition2) ?? 100,
                    subtractionLowerBound1: Int(lbsubtraction1) ?? 2,
                    subtractionUpperBound1: Int(ubsubtraction1) ?? 100,
                    subtractionLowerBound2: Int(lbsubtraction2) ?? 2,
                    subtractionUpperBound2: Int(ubsubtraction2) ?? 100,
                    multiplicationLowerBound1: Int(lbmultiplication1) ?? 2,
                    multiplicationUpperBound1: Int(ubmultiplication1) ?? 12,
                    multiplicationLowerBound2: Int(lbmultiplication2) ?? 2,
                    multiplicationUpperBound2: Int(ubmultiplication2) ?? 100,
                    divisionLowerBound1: Int(lbdivision1) ?? 2,
                    divisionUpperBound1: Int(ubdivision1) ?? 100,
                    divisionLowerBound2: Int(lbdivision2) ?? 2,
                    divisionUpperBound2: Int(ubdivision2) ?? 12
                )) {
                    Text("Start Game")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ContentView(
                    additionEnabled: $additionEnabled,
                    subtractionEnabled: $subtractionEnabled,
                    multiplicationEnabled: $multiplicationEnabled,
                    divisionEnabled: $divisionEnabled,
                    lbaddition1: $lbaddition1,
                    ubaddition1: $ubaddition1,
                    lbaddition2: $lbaddition2,
                    ubaddition2: $ubaddition2,
                    lbsubtraction1: $lbsubtraction1,
                    ubsubtraction1: $ubsubtraction1,
                    lbsubtraction2: $lbsubtraction2,
                    ubsubtraction2: $ubsubtraction2,
                    lbmultiplication1: $lbmultiplication1,
                    ubmultiplication1: $ubmultiplication1,
                    lbmultiplication2: $lbmultiplication2,
                    ubmultiplication2: $ubmultiplication2,
                    lbdivision1: $lbdivision1,
                    ubdivision1: $ubdivision1,
                    lbdivision2: $lbdivision2,
                    ubdivision2: $ubdivision2,
                    timeLimit: $timeLimit
                )) {
                    Text("Settings")
                        .font(.title)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Add "View Data" Button
                NavigationLink(destination: ScoreGraphView()) {
                    Text("View Data")
                        .font(.title)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
    }
}
