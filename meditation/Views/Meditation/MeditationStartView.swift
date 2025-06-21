import SwiftUI


struct MeditationStartView: View {
    let durationMinutes: Int
    let mood: Mood
    let music: String
    let onFinish: (() -> Void)?

    @State private var remainingSeconds: Int = 0
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color(mood.colorName)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("명상 중...")
                    .font(.title)
                    .foregroundColor(.white)
                Text("감정: \(mood.name)")
                    .foregroundColor(.white.opacity(0.8))

                Text("\(remainingSeconds / 60)분 \(remainingSeconds % 60)초")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Button("명상 종료") {
                    endMeditation()
                    onFinish?()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .padding()
        }
        .onAppear {
            startMeditation()
        }
    }

    private func startMeditation() {
        print("🧘‍♂️ 명상 시작 - duration: \(durationMinutes)분, 음악: \(music)")

        remainingSeconds = durationMinutes * 60
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            remainingSeconds -= 1
            if remainingSeconds <= 0 {
                endMeditation()
                onFinish?()
            }
        }

        // 음악 재생은 설정 화면에서만 지원합니다.
    }

    private func endMeditation() {
        timer?.invalidate()
    }
}
