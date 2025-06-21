import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()

    private init() {}

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                completion(.success(user))
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func isSignedIn() -> Bool {
        Auth.auth().currentUser != nil
    }

    func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
}
