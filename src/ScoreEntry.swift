import Foundation

struct ScoreEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let score: Int
    let timeLimit: Int
}
