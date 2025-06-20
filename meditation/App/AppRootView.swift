import SwiftUI

struct AppRootView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        NavigationStack(path: $appState.path) {
            Group {
                if appState.isLoggedIn {
                    MainTabView()
                } else {
                    LaunchView { route in
                        appState.navigate(to: route)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                routeView(route)
            }
        }
        .environmentObject(appState)
    }

    @ViewBuilder
    private func routeView(_ route: Route) -> some View {
        switch route {
        case .launch:
            LaunchView(navigate: appState.navigate)

        case .login:
            LoginView(navigate: appState.navigate)

        case .signup:
            SignupView(navigate: appState.navigate)

        case .home:
            MainTabView()

        case .content(let mood):
            ContentView(
                mood: mood,
                navigate: appState.navigate
            )

        case .meditationSetup(let mood):
            MeditationSetupView(
                mood: mood,
                navigate: appState.navigate
            )

        case .meditation(let duration, let mood, let music):
            MeditationStartView(
                durationMinutes: duration,
                mood: mood,
                music: music,
                onFinish: { actualDuration in
                    appState.navigate(to: .meditationSummary(duration: actualDuration, mood: mood))
                }
            )

        case .meditationSummary(let duration, let mood):
            MeditationSummaryView(
                durationMinutes: duration,
                mood: mood
            )

        case .journalEditor(let entry):
            if let entry = entry {
                JournalEditorView(entry: entry)
            } else {
                Text("저널 데이터를 불러올 수 없습니다.")
            }

        case .stats:
            StatsTabView()

        case .settings:
            SettingsView()

        case .profile:
            ProfileTabView()
        }
    }
}
