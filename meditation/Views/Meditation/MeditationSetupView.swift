import SwiftUI

/// Represents a background music option.
/// `id` is used as the audio file name.
struct MusicOption: Identifiable, Hashable {
    let id: String      // file name
    let displayName: String

    /// Predefined list of available music tracks.
    static let all: [MusicOption] = [
        MusicOption(id: "meditation1", displayName: "비 오는 소리"),
        MusicOption(id: "meditation2", displayName: "싱잉볼"),
        MusicOption(id: "meditation3", displayName: "새 우는 소리")
    ]
}

struct MeditationSetupView: View {
    let mood: Mood
    let navigate: (Route) -> Void

    @State private var duration: Int = 5
    @State private var selectedMusic: MusicOption = MusicOption.all.first!
    /// Tracks whether we are navigating to the meditation screen. Used to avoid
    /// stopping the music after `MeditationStartView` begins playback.
    @State private var isNavigatingToMeditation = false

    private let musicOptions = MusicOption.all

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text(mood.emoji)
                        .font(.system(size: 64))
                    Text(mood.name)
                        .font(.title2.bold())
                }
                .padding(.top)

                VStack(spacing: 16) {
                    Text("명상 시간")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("시간 선택", selection: $duration) {
                        ForEach(1...60, id: \.self) { minute in
                            Text("\(minute)분").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("배경 음악")
                        .font(.headline)
                    Picker("음악", selection: $selectedMusic) {
                        ForEach(musicOptions) { option in
                            Text(option.displayName)
                                .tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal)

                RoundedButton(title: "명상 시작하기", backgroundColor: Color(mood.colorName)) {
                    isNavigatingToMeditation = true
                    AudioPlayerService.shared.stop()
                    navigate(.meditation(duration: duration, mood: mood, music: selectedMusic.id))
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(mood.colorName).opacity(0.1))
        .navigationTitle("명상 설정")
        .onAppear {
            AudioPlayerService.shared.play(name: selectedMusic.id, loop: true)
        }
        .onChange(of: selectedMusic) { _ in
            AudioPlayerService.shared.play(name: selectedMusic.id, loop: true)
        }
        .onDisappear {
            if !isNavigatingToMeditation {
                AudioPlayerService.shared.stop()
            }
            // Reset flag for the next appearance
            isNavigatingToMeditation = false
        }
    }

}
