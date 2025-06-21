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
    @Published var weeklyGoal: Int = UserDefaults.standard.integer(forKey: "weeklyGoal") {
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

        // Entries that fall within the current calendar week
        let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date())
        let weekStart = weekInterval?.start ?? Date()
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) ?? Date()
        let thisWeekEntries = entries.filter { $0.date >= weekStart && $0.date < weekEnd }

        for entry in filtered {
            moodDict[entry.mood, default: 0] += 1
            minutesSum += entry.durationMinutes
            longest = max(longest, entry.durationMinutes)
        }

        // Populate weekly stats for each day of the current week
        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: i, to: weekStart) else { continue }
            let weekday = calendar.component(.weekday, from: date)
            let day = calendar.weekdaySymbols[weekday - 1]
            let hasSession = thisWeekEntries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            weekly[day] = hasSession
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
