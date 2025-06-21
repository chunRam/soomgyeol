import SwiftUI

struct LaunchView: View {
    @StateObject private var authViewModel = AuthViewModel()
    let navigate: (Route) -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // 앱 로고 및 이름
            VStack(spacing: 12) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)

                Text("숨결")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
            }

            // 이메일 입력
            VStack(spacing: 12) {
                TextField("Email", text: $authViewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                SecureField("Password", text: $authViewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // 에러 메시지
            if let error = authViewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            // 로그인 / 회원가입 버튼
            VStack(spacing: 12) {
                Button(action: {
                    authViewModel.signIn {
                        navigate(.home)
                    }
                }) {
                    Text("로그인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Button(action: {
                    authViewModel.signUp {
                        navigate(.home)
                    }
                }) {
                    Text("회원가입")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }

                Button("게스트로 시작") {
                    navigate(.home)
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
