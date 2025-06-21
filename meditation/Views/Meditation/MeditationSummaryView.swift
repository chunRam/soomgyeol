import SwiftUI

struct MeditationSummaryView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var journalViewModel = JournalViewModel()

    let durationMinutes: Int
    let mood: Mood

    @State private var memo: String = ""
    @State private var isSaving: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("명상 완료")
                .font(.title2)
                .fontWeight(.bold)

            VStack(spacing: 8) {
                Text("감정: \(mood.name)")
                Text("명상 시간: \(durationMinutes)분")
            }
            .foregroundColor(.secondary)

            ZStack(alignment: .topLeading) {
                if memo.isEmpty {
                    Text("메모를 작성해보세요…")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }

                TextEditor(text: $memo)
                    .frame(height: 160)
                    .padding(4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }

            if isSaving {
                ProgressView()
            } else {
                Button(action: saveEntry) {
                    Text("저장")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("명상 기록")
        .alert("오류", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func saveEntry() {
        isSaving = true
        journalViewModel.saveJournal(mood: mood.name, text: memo, durationMinutes: durationMinutes) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success:
                    appState.navigate(to: .home)
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}
