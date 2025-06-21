import Foundation
import FirebaseFirestore
import FirebaseAuth
import Network

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let store = LocalJournalStore.shared
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = true

    init() {
        startNetworkMonitor()
    }
    
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

        store.addEntry(entry)
        entries.insert(entry, at: 0)

        guard isConnected else {
            store.addPendingAction(PendingJournalAction(type: .add, entry: entry))
            completion(.success(()))
            return
        }

        do {
            let data = try Firestore.Encoder().encode(entry)
            db.collection("users").document(userId)
                .collection("journals")
                .document(entry.id)
                .setData(data) { [weak self] error in
                    if let error = error {
                        self?.store.addPendingAction(PendingJournalAction(type: .add, entry: entry))
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
        } catch {
            store.addPendingAction(PendingJournalAction(type: .add, entry: entry))
            completion(.failure(error))
        }
    }

    // MARK: - 감정 일기 수정
    func updateJournal(entry: JournalEntry, newText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인 상태가 아닙니다."])) )
            return
        }

        let updated = JournalEntry(
            id: entry.id,
            mood: entry.mood,
            text: newText,
            durationMinutes: entry.durationMinutes,
            date: entry.date
        )

        store.updateEntry(updated)
        if let index = entries.firstIndex(where: { $0.id == updated.id }) {
            entries[index] = updated
        }

        guard isConnected else {
            store.addPendingAction(PendingJournalAction(type: .update, entry: updated))
            completion(.success(()))
            return
        }

        do {
            let data = try Firestore.Encoder().encode(updated)
            db.collection("users").document(userId)
                .collection("journals")
                .document(entry.id)
                .setData(data) { [weak self] error in
                    if let error = error {
                        self?.store.addPendingAction(PendingJournalAction(type: .update, entry: updated))
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
        } catch {
            store.addPendingAction(PendingJournalAction(type: .update, entry: updated))
            completion(.failure(error))
        }
    }

    // MARK: - 감정 일기 삭제
    func deleteJournal(entry: JournalEntry, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "로그인 상태가 아닙니다."])) )
            return
        }

        store.deleteEntry(id: entry.id)
        entries.removeAll { $0.id == entry.id }

        guard isConnected else {
            store.addPendingAction(PendingJournalAction(type: .delete, entry: entry))
            completion(.success(()))
            return
        }

        db.collection("users").document(userId)
            .collection("journals")
            .document(entry.id)
            .delete { [weak self] error in
                if let error = error {
                    self?.store.addPendingAction(PendingJournalAction(type: .delete, entry: entry))
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    // MARK: - 감정 일기 불러오기
    func fetchJournals() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        guard isConnected else {
            entries = store.loadEntries().sorted { $0.date > $1.date }
            return
        }

        listener = db.collection("users").document(userId)
            .collection("journals")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
                if let documents = snapshot?.documents {
                    var fetched: [JournalEntry] = []
                    for doc in documents {
                        if var entry = try? doc.data(as: JournalEntry.self) {
                            if Mood.mood(for: entry.mood) == nil,
                               let id = Mood.id(forName: entry.mood) {
                                // migrate mood name to id
                                entry = JournalEntry(
                                    id: entry.id,
                                    mood: id,
                                    text: entry.text,
                                    durationMinutes: entry.durationMinutes,
                                    date: entry.date
                                )
                                // update remote document
                                try? doc.reference.setData(from: entry)
                            }
                            fetched.append(entry)
                        }
                    }
                    self.entries = fetched
                    self.store.saveEntries(fetched)
                }
            }
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

    // MARK: - Network Monitoring
    private func startNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let connected = path.status == .satisfied
                if connected && self?.isConnected == false {
                    self?.syncPendingActions()
                }
                self?.isConnected = connected
            }
        }
        monitor.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }

    private func syncPendingActions() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var actions = store.loadPendingActions()
        guard !actions.isEmpty else { return }

        for action in actions {
            switch action.type {
            case .add, .update:
                do {
                    var entry = action.entry
                    if Mood.mood(for: entry.mood) == nil,
                       let id = Mood.id(forName: entry.mood) {
                        entry = JournalEntry(
                            id: entry.id,
                            mood: id,
                            text: entry.text,
                            durationMinutes: entry.durationMinutes,
                            date: entry.date
                        )
                        store.updateEntry(entry)
                    }
                    let data = try Firestore.Encoder().encode(entry)
                    db.collection("users").document(userId)
                        .collection("journals")
                        .document(entry.id)
                        .setData(data) { [weak self] error in
                            if error == nil {
                                self?.store.removePendingAction(id: entry.id, type: action.type)
                            }
                        }
                } catch {
                    continue
                }
            case .delete:
                db.collection("users").document(userId)
                    .collection("journals")
                    .document(action.entry.id)
                    .delete { [weak self] error in
                        if error == nil {
                            self?.store.removePendingAction(id: action.entry.id, type: action.type)
                        }
                    }
            }
        }
    }
}
