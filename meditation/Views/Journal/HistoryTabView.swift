import SwiftUI

struct HistoryTabView: View {
    @StateObject private var viewModel = JournalViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                    ForEach(viewModel.entries) { entry in
                        let mood = Mood.mood(for: entry.mood)

                        HStack(alignment: .top, spacing: 12) {
                            if let mood = mood {
                                Text(mood.emoji)
                                    .font(.title)
                                    .frame(width: 44, height: 44)
                                    .background(Color(mood.colorName))
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("🗓️ \(entry.date.formatted(.dateTime.year().month().day()))")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                if let mood = mood {
                                    Text(mood.name)
                                        .font(.headline)
                                } else {
                                    Text(entry.mood)
                                        .font(.headline)
                                }

                                Text(entry.text)
                                    .lineLimit(3)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(mood?.colorName ?? "white").opacity(0.1))
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 2)
                        .padding(.horizontal)
                        .onTapGesture {
                            appState.navigate(to: .journalEditor(entry: entry))
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.deleteJournal(entry: entry) { _ in }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addEntry) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.fetchJournals()
        }
        .onDisappear {
            viewModel.removeListener()
        }
    }

    private func addEntry() {
        let mood = Mood.sampleMoods.first?.id ?? ""
        let newEntry = JournalEntry(
            mood: mood,
            text: "",
            durationMinutes: 0,
            date: Date()
        )
        appState.navigate(to: .journalEditor(entry: newEntry))
    }
}
