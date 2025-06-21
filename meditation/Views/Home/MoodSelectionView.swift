import SwiftUI

struct MoodSelectionView: View {
    @EnvironmentObject var appState: AppState
    private let moods = Mood.sampleMoods
    @State private var selectedMood: Mood?

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("오늘의 기분은 어때요?")
                    .font(.system(size: 22, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(moods) { mood in
                        MoodCardView(mood: mood, isSelected: selectedMood == mood)
                            .onTapGesture {
                                selectedMood = mood
                            }
                    }
                }
                .padding(.horizontal)

                if let mood = selectedMood {
                    RoundedButton(title: "선택", backgroundColor: Color(mood.colorName)) {
                        appState.navigate(to: .content(mood))
                    }
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(), value: selectedMood)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("감정 선택")
    }
}

