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

    @State private var duration: Double = 5
    @State private var selectedMusic: MusicOption = MusicOption.all.first!
    /// Tracks whether we are navigating to the meditation screen. Used to avoid
    /// stopping the music after `MeditationStartView` begins playback.
    @State private var isNavigatingToMeditation = false

    private let musicOptions = MusicOption.all

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack {
                Text("명상 시간: \(Int(duration))분")
                    .font(.title2)
                Picker("시간 선택", selection: $duration) {
                    ForEach(1...60, id: \.self) { minute in
                        Text("\(minute)분").tag(minute)
                    }
                }
                .pickerStyle(.wheel)
            }
            .padding()
          
            VStack(alignment: .leading, spacing: 12) {
                Text("배경 음악")
                    .font(.title3)
                Picker("음악", selection: $selectedMusic) {
                    ForEach(musicOptions) { option in
                        Text(option.displayName)
                            .tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()

            Spacer()

            Button(action: {
                isNavigatingToMeditation = true
                AudioPlayerService.shared.stop()
                navigate(.meditation(duration: Int(duration), mood: mood, music: selectedMusic.id))
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