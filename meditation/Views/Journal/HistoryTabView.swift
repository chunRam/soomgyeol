import SwiftUI

struct HistoryTabView: View {
    @StateObject private var viewModel = JournalViewModel()
    @EnvironmentObject var appState: AppState
    /// Text used for searching journal entries by mood name or text content.
    @State private var searchText = ""
    /// Optional mood identifier used to limit results to a specific mood.
    @State private var selectedMoodID: String?

    /// Filtered list of journal entries matching the current search criteria.
    private var filteredEntries: [JournalEntry] {
        viewModel.entries.filter { entry in
            // Check the optional mood picker filter first
            let matchesMood = selectedMoodID == nil || selectedMoodID == entry.mood

            // If there is no search text we only care about the mood filter
            guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                return matchesMood
            }

            // Compare against mood name and entry text
            let moodName = Mood.mood(for: entry.mood)?.name ?? entry.mood
            let inMood = moodName.localizedCaseInsensitiveContains(searchText)
            let inText = entry.text.localizedCaseInsensitiveContains(searchText)

            return matchesMood && (inMood || inText)
        }
    }

    var body: some View {
        ZStack {
            Color("PastelMint")
                .brightness(0.1)

            ScrollView {
                VStack(spacing: 12) {
                Picker("감정 필터", selection: $selectedMoodID) {
                    Text("전체").tag(String?.none)
                    ForEach(Mood.sampleMoods) { mood in
                        Text(mood.name).tag(Optional(mood.id))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                LazyVStack(spacing: 16) {
                    ForEach(filteredEntries) { entry in
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

                    if filteredEntries.isEmpty {
                        Text("아직 작성된 감정 일지가 없어요.")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }
                }
                .padding(.top)
            }
            .background(
                Color("PastelMint")
                    .brightness(-0.1)
            )
        }
        .searchable(text: $searchText, prompt: "검색")
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
        .background(Color.white.ignoresSafeArea())
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
}
