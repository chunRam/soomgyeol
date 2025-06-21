import SwiftUI

struct ContentView: View {
    let mood: Mood
    let navigate: (Route) -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("오늘의 감정")
                .font(.title3)
                .foregroundColor(.gray)

            Text(mood.name)
                .font(.largeTitle.bold())
                .foregroundColor(Color(mood.colorName)) // ✅ 수정

            Text(mood.message)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.primary)

            Spacer()

            Button(action: {
                navigate(.meditationSetup(mood))
            }) {
                Text("명상 시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(mood.colorName)) // ✅ 수정
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("감정 정리")
    }
}
