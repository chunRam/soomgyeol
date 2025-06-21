import Foundation
import AVFoundation

class AudioPlayerService {
    static let shared = AudioPlayerService()
    private var player: AVAudioPlayer?

    private init() {}

    func play(name: String, fileExtension: String = "mp3", loops: Int = 0) {
        stop()
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("오디오 파일을 찾을 수 없습니다: \(name)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loops
            player?.play()
        } catch {
            print("오디오 재생 오류: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}

