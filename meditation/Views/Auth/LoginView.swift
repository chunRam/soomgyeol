import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
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
            }

            VStack(spacing: 12) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            VStack(spacing: 12) {
                RoundedButton(title: "로그인", backgroundColor: .green) {
                    viewModel.signIn(appState: appState) {
                        navigate(.home)
                    }
                }

                Button("회원가입") {
                    navigate(.signup)
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

