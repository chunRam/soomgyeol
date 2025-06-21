import SwiftUI
import AVFoundation

struct MeditationStartView: View {
    let durationMinutes: Int
    let mood: Mood
    let music: String
    let onFinish: (() -> Void)?

    @State private var remainingSeconds: Int = 0
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
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
        .background(Color(mood.colorName)) // ✅ 수정: View에서 직접 Color 생성
        .ignoresSafeArea()
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

        if let url = Bundle.main.url(forResource: music, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                print("🎵 음악 재생 시작: \(music)")
            } catch {
                print("❌ 오디오 재생 실패: \(error.localizedDescription)")
            }
        } else {
            print("⚠️ 음악 파일 '\(music).mp3' 을 찾을 수 없습니다.")
        }
    }

    private func endMeditation() {
        timer?.invalidate()
        audioPlayer?.stop()
    }
}
