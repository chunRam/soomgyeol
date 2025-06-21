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

                Button(action: {
                    navigate(.home)
                }) {
                    Text("게스트 모드로 시작하기")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                .foregroundColor(.primary)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
