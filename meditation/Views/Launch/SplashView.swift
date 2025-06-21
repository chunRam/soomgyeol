import SwiftUI

struct SplashView: View {
    let navigate: (Route) -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                Text("숨결")
                    .font(.largeTitle.bold())
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                navigate(.launch)
            }
        }
    }
}

