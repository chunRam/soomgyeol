import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("앱 설정")) {
                Toggle("알림 받기", isOn: .constant(true))
                Toggle("DND 모드 자동 켜기", isOn: .constant(false))
            }

            Section(header: Text("앱 정보")) {
                HStack {
                    Text("버전")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                Link("개발자 GitHub", destination: URL(string: "https://github.com/yourname")!)
            }

            Section {
                Button(role: .destructive) {
                    do {
                        try Auth.auth().signOut()
                        appState.reset()
                    } catch {
                        print("로그아웃 오류: \(error)")
                    }
                } label: {
                    Text("로그아웃")
                }
            }
        }
        .navigationTitle("설정")
    }
}
