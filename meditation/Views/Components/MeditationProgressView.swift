import SwiftUI

struct MeditationProgressView: View {
    let progress: Double
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 140, height: 140)
        .animation(.easeInOut, value: progress)
    }
}

