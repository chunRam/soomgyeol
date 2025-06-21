import AVFoundation

final class AudioPlayerService {
    static let shared = AudioPlayerService()
    private var player: AVAudioPlayer?

    /// Play an audio file located in the app bundle.
    /// - Parameters:
    ///   - name: Resource name without extension.
    ///   - loop: Whether the audio should loop indefinitely.
    func play(name: String, loop: Bool = true) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("음악 파일을 찾을 수 없습니다: \(name)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loop ? -1 : 0
            player?.play()
        } catch {
            print("오디오 재생 실패: \(error.localizedDescription)")
        }
    }

    /// Pause playback.
    func pause() {
        player?.pause()
    }

    /// Resume playback after pause.
    func resume() {
        player?.play()
    }

    /// Stop playback completely.
    func stop() {
        player?.stop()
        player = nil
    }
}