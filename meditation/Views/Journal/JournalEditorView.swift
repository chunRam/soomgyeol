import SwiftUI

struct JournalEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var viewModel = JournalViewModel()
    let entry: JournalEntry

    @State private var text: String
    @State private var isSaving: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    init(entry: JournalEntry) {
        self.entry = entry
        _text = State(initialValue: entry.text)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("감정 일기 작성")
                .font(.title2)
                .fontWeight(.bold)

            Text("오늘 느꼈던 감정과 생각을 자유롭게 적어보세요.")
                .font(.subheadline)
                .foregroundColor(.gray)

            TextEditor(text: $text)
                .frame(height: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

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
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
        .alert("오류", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func saveEntry() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "내용을 입력해주세요."
            showAlert = true
            return
        }

        isSaving = true

        viewModel.saveJournal(mood: entry.mood, text: text, durationMinutes: entry.durationMinutes) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success:
                    dismiss()
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}
