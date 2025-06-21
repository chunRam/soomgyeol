import Foundation
import FirebaseAuth
import FirebaseFirestore

class StatsViewModel: ObservableObject {
    @Published var moodCount: [String: Int] = [:]
    @Published var totalMinutes: Int = 0
    @Published var weeklyStats: [String: Bool] = [:]
    @Published var hasError: Bool = false
    @Published var errorMessage: String?

    private let db = Firestore.firestore()

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
                    return
                }

                guard let documents = snapshot?.documents else { return }

                var moodDict: [String: Int] = [:]
                var minutesSum = 0
                var weekly: [String: Bool] = [:]
                let calendar = Calendar.current

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
                        moodDict[entry.mood, default: 0] += 1
                        minutesSum += entry.durationMinutes

                        let weekday = calendar.component(.weekday, from: entry.date)
                        let day = calendar.weekdaySymbols[weekday - 1]
                        weekly[day] = true
                    }
                }

                DispatchQueue.main.async {
                    self.moodCount = moodDict
                    self.totalMinutes = minutesSum
                    self.weeklyStats = weekly
                }
            }
    }
}
