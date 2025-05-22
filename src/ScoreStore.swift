import Foundation

final class ScoreStore: ObservableObject {
    @Published private(set) var scores: [ScoreEntry] = []

    private let url: URL = {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("scores.json")
    }()

    init() { load() }

    func add(_ entry: ScoreEntry) {
        scores.append(entry)
        save()
    }

    // MARK: − Persistence
    private func load() {
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([ScoreEntry].self, from: data) else { return }
        scores = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(scores) else { return }
        try? data.write(to: url, options: [.atomic])
    }
}
