import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    func signIn(appState: AppState, completion: @escaping () -> Void) {
        AuthService.shared.signIn(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let firebaseUser):
                    appState.user = User(firebaseUser: firebaseUser)
                    self.isAuthenticated = true
                    completion()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func signUp(appState: AppState, completion: @escaping () -> Void) {
        AuthService.shared.signUp(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let firebaseUser):
                    appState.user = User(firebaseUser: firebaseUser)
                    self.isAuthenticated = true
                    completion()
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
