import SwiftUI

struct HomeView: View {
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
    

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("ZetaMax")
                    .font(.system(size: 36, weight: .medium))
                
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
                    Text("Play Game")
                        .font(.system(size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.9))
                        .cornerRadius(5)
                }
                
                NavigationLink(destination: ContentView()) {
                    Text("Settings")
                        .font(.system(size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.9))
                        .cornerRadius(5)
                }
                
                NavigationLink(destination: ScoreGraphView()) {
                    Text("View Data")
                        .font(.system(size: 20))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.9))
                        .cornerRadius(5)
                }

                Spacer()
            }
            .padding()
        }
    }
}


struct HomeView_Previews_Alternate: PreviewProvider {
    static var previews: some View {
        HomeView()  
    }
}

