import SwiftUI

struct HistoryTabView: View {
    @StateObject private var viewModel = JournalViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                    ForEach(viewModel.entries) { entry in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🗓️ \(entry.date.formatted(.dateTime.year().month().day()))")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Text("감정: \(entry.mood)")
                                .font(.headline)

                            Text(entry.text)
                                .lineLimit(3)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            appState.navigate(to: .journalEditor(entry: entry))
                        }
                    }

                    if viewModel.entries.isEmpty {
                        Text("아직 작성된 감정 일지가 없어요.")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }
                }
                .padding(.top)
        }
        .background(Color("SoftGray").ignoresSafeArea())
        .navigationTitle("감정 일지")
        .onAppear {
            viewModel.fetchJournals()
        }
    }
}
