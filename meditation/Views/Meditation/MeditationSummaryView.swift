import SwiftUI

struct MeditationSummaryView: View {
    let durationMinutes: Int
    let mood: Mood
    let onDone: () -> Void

    @State private var note: String = ""
    @State private var isSaving = false
    @StateObject private var journalViewModel = JournalViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Text("명상 완료")
                .font(.title)

            Text("\(durationMinutes)분 동안 \(mood.name) 명상을 했어요")
                .foregroundColor(.secondary)

            TextEditor(text: $note)
                .frame(height: 120)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    Group {
                        if note.isEmpty {
                            Text("느낀 점을 기록해보세요...")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                                .padding(.top, 12)
                                .allowsHitTesting(false)
                        }
                    }, alignment: .topLeading
                )

            if isSaving {
                ProgressView()
            } else {
                RoundedButton(title: "저장", backgroundColor: Color(mood.colorName)) {
                    save()
                }
            }

            Spacer()
        }
        .padding()
    }

    private func save() {
        isSaving = true
        journalViewModel.saveJournal(mood: mood.name, text: note, durationMinutes: durationMinutes) { _ in
            DispatchQueue.main.async {
                isSaving = false
                onDone()
            }
        }
    }
}

