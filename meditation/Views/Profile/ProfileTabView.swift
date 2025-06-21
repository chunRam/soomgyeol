import SwiftUI
import FirebaseAuth

struct ProfileTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var userEmail: String = Auth.auth().currentUser?.email ?? "Unknown"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // 사용자 이메일 표시
                VStack(spacing: 4) {
                    Text("Logged in as")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(userEmail)
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                // 로그아웃 버튼
                Button(action: {
                    logout()
                }) {
                    Text("로그아웃")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                // 앱 정보 표시
                VStack(spacing: 4) {
                    Text("앱 버전 \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("© 2025 Soomgyeol")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.top, 60)
            .navigationTitle("프로필")
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            appState.navigate(to: .launch) // ✅ AppRootView에서 LaunchView로 이동
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}
