import Foundation

struct JournalEntry: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    let mood: String
    let text: String
    let durationMinutes: Int
    let date: Date
}
