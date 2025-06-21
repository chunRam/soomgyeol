import Foundation
import FirebaseFirestore
import FirebaseAuth

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    
    private let db = Firestore.firestore()
    
    // MARK: - 감정 일기 저장
    func saveJournal(mood: String, text: String, durationMinutes: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인 상태가 아닙니다."])))
            return
        }
        
        let entry = JournalEntry(
            mood: mood,
            text: text,
            durationMinutes: durationMinutes,
            date: Date()
        )
        
        do {
            let data = try Firestore.Encoder().encode(entry)
            db.collection("users").document(userId)
                .collection("journals")
                .document(entry.id)
                .setData(data) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - 감정 일기 불러오기
    func fetchJournals() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId)
            .collection("journals")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let documents = snapshot?.documents {
                    self.entries = documents.compactMap { doc in
                        try? doc.data(as: JournalEntry.self)
                    }
                }
            }
    }
}
