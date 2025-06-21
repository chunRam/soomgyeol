import SwiftUI
import FirebaseAuth

class AppState: ObservableObject {
    @Published var path: [Route] = []
    @Published var isLoggedIn: Bool = false
    /// Currently selected mood color to sync backgrounds across tabs.
    @Published var currentMoodColor: String? = nil

    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        observeAuthChanges()
    }

    private func observeAuthChanges() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = (user != nil)
                if user == nil {
                    self?.path = []
                }
            }
        }
    }

    func navigate(to route: Route) {
        switch route {
        case .launch:
            path = []
            isLoggedIn = false
        case .home:
            path = []
            isLoggedIn = true
        default:
            path.append(route)
        }
    }

    func reset() {
        path = []
        isLoggedIn = false
    }

    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
