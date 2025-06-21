import Foundation
import FirebaseCore

class FirebaseManager {
    static let shared = FirebaseManager()

    private init() {}

    func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

