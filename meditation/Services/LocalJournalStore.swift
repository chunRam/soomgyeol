import Foundation

struct PendingJournalAction: Codable {
    enum ActionType: String, Codable {
        case add
        case update
        case delete
    }

    let type: ActionType
    let entry: JournalEntry
}

class LocalJournalStore {
    static let shared = LocalJournalStore()

    private let entriesURL: URL
    private let pendingURL: URL

    private init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        entriesURL = dir.appendingPathComponent("journal_entries.json")
        pendingURL = dir.appendingPathComponent("pending_journal_actions.json")
    }

    // MARK: - Entries
    func loadEntries() -> [JournalEntry] {
        guard let data = try? Data(contentsOf: entriesURL) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let entries = (try? decoder.decode([JournalEntry].self, from: data)) ?? []

        // Migrate legacy mood names to identifiers
        var migrated = entries
        var didMigrate = false
        for i in migrated.indices {
            if Mood.mood(for: migrated[i].mood) == nil,
               let id = Mood.id(forName: migrated[i].mood) {
                migrated[i] = JournalEntry(
                    id: migrated[i].id,
                    mood: id,
                    text: migrated[i].text,
                    durationMinutes: migrated[i].durationMinutes,
                    date: migrated[i].date
                )
                didMigrate = true
            }
        }
        if didMigrate { saveEntries(migrated) }
        return migrated
    }

    func saveEntries(_ entries: [JournalEntry]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            try? data.write(to: entriesURL)
        }
    }

    // MARK: - Pending Actions
    func loadPendingActions() -> [PendingJournalAction] {
        guard let data = try? Data(contentsOf: pendingURL) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([PendingJournalAction].self, from: data)) ?? []
    }

    func savePendingActions(_ actions: [PendingJournalAction]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(actions) {
            try? data.write(to: pendingURL)
        }
    }

    func addPendingAction(_ action: PendingJournalAction) {
        var actions = loadPendingActions()
        actions.append(action)
        savePendingActions(actions)
    }

    func removePendingAction(id: String, type: PendingJournalAction.ActionType) {
        var actions = loadPendingActions()
        actions.removeAll { $0.entry.id == id && $0.type == type }
        savePendingActions(actions)
    }

    // Convenience operations on entries
    func addEntry(_ entry: JournalEntry) {
        var entries = loadEntries()
        entries.append(entry)
        saveEntries(entries)
    }

    func updateEntry(_ entry: JournalEntry) {
        var entries = loadEntries()
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries(entries)
        }
    }

    func deleteEntry(id: String) {
        var entries = loadEntries()
        entries.removeAll { $0.id == id }
        saveEntries(entries)
    }
}
