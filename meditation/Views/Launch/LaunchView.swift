import SwiftUI

struct LaunchView: View {
    let navigate: (Route) -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)

                Text("숨결")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
            }

            VStack(spacing: 12) {
                RoundedButton(title: "로그인", backgroundColor: .green) {
                    navigate(.login)
                }

                RoundedButton(
                    title: "회원가입",
                    backgroundColor: .gray.opacity(0.2),
                    textColor: .primary
                ) {
                    navigate(.signup)
                }

                Button("게스트 모드로 시작하기") {
                    navigate(.home)
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}