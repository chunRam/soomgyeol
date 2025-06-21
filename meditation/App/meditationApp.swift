import SwiftUI
import FirebaseCore

@main
struct meditationApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView() // ✅ 전역 경로 관리 및 로그인 상태 판별
        }
    }
}
