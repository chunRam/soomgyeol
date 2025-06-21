import SwiftUI

struct HomeTabView: View {
    @State private var selectedMood: Mood? = nil
    @EnvironmentObject var appState: AppState

    let moods: [Mood] = Mood.sampleMoods
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color(appState.currentMoodColor ?? "SoftGray")
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    DailyQuoteView()
                        .padding(.top)

                Text("오늘의 기분은 어때요?")
                    .font(.system(size: 22, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(moods) { mood in
                        let isSelected = selectedMood == mood

                        MoodCardView(mood: mood, isSelected: isSelected)
                            .onTapGesture {
                                selectedMood = mood
                                appState.currentMoodColor = mood.colorName
                            }
                    }
                }
                .padding(.horizontal)

                    if let mood = selectedMood {
                        Button(action: {
                            appState.navigate(to: .content(mood))
                        }) {
                            Text("명상 시작하기")
                                .font(.system(size: 18, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(mood.colorName)) // ✅ 수정
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                        .padding(.top, 16)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(), value: selectedMood)
                    }
                }
                .padding(.vertical)
            }
            .background(
                Color(appState.currentMoodColor ?? "SoftGray")
                    .brightness(-0.1)
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
