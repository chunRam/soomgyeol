import SwiftUI
import AVFoundation

struct MeditationSetupView: View {
    let mood: Mood
    let navigate: (Route) -> Void

    @State private var duration: Int = 5
    @State private var selectedMusic: String = "meditation1"
    @State private var audioPlayer: AVAudioPlayer?

    private let musicOptions = ["meditation1", "meditation2", "meditation3"]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack {
                Text("명상 시간: \(duration)분")
                    .font(.title2)
                Stepper("시간 선택", value: $duration, in: 1...60)
            }
            .padding()

            VStack(alignment: .leading, spacing: 12) {
                Text("배경 음악")
                    .font(.title3)
                Picker("음악", selection: $selectedMusic) {
                    ForEach(musicOptions, id: \.self) { option in
                        Text(option)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            Spacer()

            Button(action: {
                audioPlayer?.stop()
                navigate(.meditation(duration: duration, mood: mood, music: selectedMusic))
            }) {
                Text("명상 시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(mood.colorName))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle("명상 설정")
        .onAppear(perform: playMusic)
        .onChange(of: selectedMusic) { _ in
            playMusic()
        }
        .onDisappear {
            audioPlayer?.stop()
        }
    }

    private func playMusic() {
        guard let url = Bundle.main.url(forResource: selectedMusic, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("오디오 재생 실패: \(error.localizedDescription)")
        }
    }
}