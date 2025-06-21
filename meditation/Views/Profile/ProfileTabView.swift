import SwiftUI
import FirebaseAuth

struct ProfileTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 24) {
            // 헤더 프로필 이미지와 이메일
            VStack(spacing: 8) {
                if let url = appState.user?.profileImageURL {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(
                                    LinearGradient(colors: [Color("SoftGreen"), Color("SoftBlue")], startPoint: .top, endPoint: .bottom)
                                )
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(
                            LinearGradient(colors: [Color("SoftGreen"), Color("SoftBlue")], startPoint: .top, endPoint: .bottom)
                        )
                }

                Text(appState.user?.displayName ?? "Unknown")
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(.horizontal)

            // 로그아웃 버튼
            Button(action: logout) {
                Text("로그아웃")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color("SoftBlue"), Color("DeepIndigo")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal)

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
        .padding(.top, 40)
        .navigationTitle("프로필")
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
