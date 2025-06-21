import Foundation
import AVFoundation

class MeditationViewModel: ObservableObject {
    @Published var remainingSeconds: Int
    @Published var isMeditating: Bool = false

    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?

    let durationMinutes: Int
    let music: String

    init(durationMinutes: Int, music: String) {
        self.durationMinutes = durationMinutes
        self.music = music
        self.remainingSeconds = durationMinutes * 60
    }

    func startMeditation() {
        isMeditating = true
        remainingSeconds = durationMinutes * 60

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.endMeditation()
            }
        }

        if let url = Bundle.main.url(forResource: music, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("오디오 재생 오류: \(error)")
            }
        }
    }

    func endMeditation() {
        timer?.invalidate()
        audioPlayer?.stop()
        isMeditating = false
    }

    var formattedTime: String {
        String(format: "%02d분 %02d초", remainingSeconds / 60, remainingSeconds % 60)
    }
}
