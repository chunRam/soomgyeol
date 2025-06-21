import SwiftUI

struct MeditationStartView: View {
    let durationMinutes: Int
    let mood: Mood
    let music: String
    /// Called when the meditation finishes. Provides the elapsed duration in minutes.
    let onFinish: ((Int) -> Void)?

    @State private var remainingSeconds: Int = 0
    @State private var timer: Timer?
    @State private var isPaused: Bool = false
    @State private var startDate: Date?

    private var totalSeconds: Int {
        durationMinutes * 60
    }

    private var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    var body: some View {
        ZStack {
            Color(mood.colorName)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("명상 중...")
                    .font(.title)
                    .foregroundColor(.white)
                Text("감정: \(mood.name)")
                    .foregroundColor(.white.opacity(0.8))

                MeditationProgressView(progress: progress, remainingSeconds: remainingSeconds)

                HStack(spacing: 40) {
                    Button(action: togglePause) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .padding()
                    }

                    Button("명상 종료") {
                        let minutes = elapsedMinutes()
                        endMeditation()
                        onFinish?(minutes)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .onAppear(perform: startMeditation)
    }

    private func startMeditation() {
        print("🧘‍♂️ 명상 시작 - duration: \(durationMinutes)분, 음악: \(music)")
        remainingSeconds = totalSeconds
        startDate = Date()
        startTimer()
        AudioPlayerService.shared.play(name: music)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            remainingSeconds -= 1
            if remainingSeconds <= 0 {
                endMeditation()
                onFinish?(elapsedMinutes())
            }
        }
    }

    private func togglePause() {
        if isPaused {
            resumeMeditation()
        } else {
            pauseMeditation()
        }
    }

    private func pauseMeditation() {
        timer?.invalidate()
        AudioPlayerService.shared.pause()
        isPaused = true
    }

    private func resumeMeditation() {
        startTimer()
        AudioPlayerService.shared.resume()
        isPaused = false
    }

    private func endMeditation() {
        timer?.invalidate()
        AudioPlayerService.shared.stop()
    }

    /// Calculates the elapsed meditation time in minutes, clamped to the
    /// originally requested duration.
    private func elapsedMinutes() -> Int {
        guard let startDate else { return durationMinutes }
        let elapsed = Date().timeIntervalSince(startDate)
        let clamped = min(elapsed, Double(totalSeconds))
        return Int(clamped / 60)
    }
}
