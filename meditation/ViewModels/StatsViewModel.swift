import Foundation
import FirebaseAuth
import FirebaseFirestore

/// View model that aggregates journal statistics from Firestore or the local cache.

class StatsViewModel: ObservableObject {
    /// Available time ranges for filtering statistics.
    enum TimeRange: String, CaseIterable, Identifiable {
        case all = "전체"
        case week = "최근 7일"
        case month = "최근 30일"

        var id: String { rawValue }

        /// Number of days for the range. `nil` means no filtering.
        var days: Int? {
            switch self {
            case .all: return nil
            case .week: return 7
            case .month: return 30
            }
        }
    }

    @Published var timeRange: TimeRange = .all {
        didSet { fetchStats() }
    }

    @Published var moodCount: [String: Int] = [:]
    @Published var totalMinutes: Int = 0
    @Published var sessionCount: Int = 0
    @Published var averageSessionMinutes: Double = 0
    @Published var longestSessionMinutes: Int = 0
    @Published var weeklyStats: [String: Bool] = [:]
    /// Weekly meditation goal in days. Defaults to `3` when no value is stored.
    @Published var weeklyGoal: Int = {
        let stored = UserDefaults.standard.integer(forKey: "weeklyGoal")
        return stored == 0 ? 3 : stored
    }() {
        didSet { UserDefaults.standard.set(weeklyGoal, forKey: "weeklyGoal") }
    }
    @Published var hasError: Bool = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()
    private let store = LocalJournalStore.shared

    init() {
        // Intentionally left blank; fetchStats() should be called explicitly
    }

    func fetchStats() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.hasError = true
            self.errorMessage = "로그인 상태가 아닙니다."
            return
        }

        db.collection("users").document(userId)
            .collection("journals")
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.hasError = true
                        self.errorMessage = error.localizedDescription
                    }
                    // Fallback to cached entries if available
                    self.computeStats(from: self.store.loadEntries())
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.computeStats(from: self.store.loadEntries())
                    return
                }

                var fetched: [JournalEntry] = []

                for doc in documents {
                    if var entry = try? doc.data(as: JournalEntry.self) {
                        if Mood.mood(for: entry.mood) == nil,
                           let id = Mood.id(forName: entry.mood) {
                            entry = JournalEntry(
                                id: entry.id,
                                mood: id,
                                text: entry.text,
                                durationMinutes: entry.durationMinutes,
                                date: entry.date
                            )
                            try? doc.reference.setData(from: entry)
                        }
                        fetched.append(entry)
                    }
                }

                // Cache entries locally for future use
                self.store.saveEntries(fetched)
                self.computeStats(from: fetched)
            }
    }

    /// Computes aggregated statistics from journal entries.
    private func computeStats(from entries: [JournalEntry]) {
        let calendar = Calendar.current

        let filtered: [JournalEntry] = {
            if let days = timeRange.days,
               let start = calendar.date(byAdding: .day, value: -days + 1, to: Date()) {
                return entries.filter { $0.date >= start }
            }
            return entries
        }()

        var moodDict: [String: Int] = [:]
        var minutesSum = 0
        var longest = 0
        var weekly: [String: Bool] = [:]

        for entry in filtered {
            moodDict[entry.mood, default: 0] += 1
            minutesSum += entry.durationMinutes
            longest = max(longest, entry.durationMinutes)

            let weekday = calendar.component(.weekday, from: entry.date)
            let day = calendar.weekdaySymbols[weekday - 1]
            weekly[day] = true
        }

        DispatchQueue.main.async {
            self.moodCount = moodDict
            self.totalMinutes = minutesSum
            self.sessionCount = filtered.count
            self.averageSessionMinutes = filtered.isEmpty ? 0 : Double(minutesSum) / Double(filtered.count)
            self.longestSessionMinutes = longest
            self.weeklyStats = weekly
        }
    }

    /// Ratio of completed meditation days to the configured weekly goal.
    var weeklyProgress: Double {
        let completed = weeklyStats.filter { $0.value }.count
        return Double(completed) / Double(max(1, weeklyGoal))
    }
}
