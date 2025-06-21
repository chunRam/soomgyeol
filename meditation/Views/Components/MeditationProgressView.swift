import SwiftUI

struct MeditationProgressView: View {
    /// Progress value between 0 and 1.
    var progress: Double
    /// Remaining time in seconds to display inside the progress circle.
    var remainingSeconds: Int

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 12)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(remainingSeconds / 60)분 \(remainingSeconds % 60)초")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 200)
    }
}

struct MeditationProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            MeditationProgressView(progress: 0.5, remainingSeconds: 150)
        }
    }
}
