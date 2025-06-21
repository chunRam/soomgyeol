import SwiftUI
import FirebaseAuth

class AppState: ObservableObject {
    @Published var path: [Route] = []
    @Published var isLoggedIn: Bool = false
    @Published var user: User?

    private var authListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        if let current = Auth.auth().currentUser {
            user = User(firebaseUser: current)
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
        observeAuthChanges()
    }

    private func observeAuthChanges() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.user = User(firebaseUser: user)
                    self?.isLoggedIn = true
                } else {
                    self?.isLoggedIn = false
                    self?.user = nil
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
