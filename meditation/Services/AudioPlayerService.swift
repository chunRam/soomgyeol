//
//  AudioPlayerService.swift
//  Meditation
//
//  Created by 김태우 on 6/20/25.
//

import Foundation
import AVFoundation

class AudioPlayerService {
    static let shared = AudioPlayerService()

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    /// Play a sound file from the app bundle.
    /// - Parameters:
    ///   - name: File name without extension.
    ///   - loop: If true the sound will loop indefinitely.
    func play(_ name: String, loop: Bool = false) {
        stop()
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = loop ? -1 : 0
            audioPlayer?.play()
        } catch {
            print("오디오 재생 실패: \(error)")
        }
    }

    /// Pause the currently playing sound.
    func pause() {
        audioPlayer?.pause()
    }

    /// Stop playing and release the audio player.
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
