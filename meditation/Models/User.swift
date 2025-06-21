//
//  User.swift
//  Meditation
//
//  Created by 김태우 on 6/20/25.
//

import Foundation
import FirebaseAuth

/// Represents an authenticated application user.
struct User: Identifiable {
    /// Unique identifier for the user (Firebase UID).
    let id: String

    /// Display name shown in the UI. Falls back to the user's email when no
    /// explicit display name is available.
    let displayName: String

    /// Optional URL to the user's profile image.
    let profileImageURL: URL?

    init(id: String, displayName: String, profileImageURL: URL? = nil) {
        self.id = id
        self.displayName = displayName
        self.profileImageURL = profileImageURL
    }

    /// Convenience initializer to create ``User`` from ``FirebaseAuth.User``.
    init(firebaseUser: FirebaseAuth.User) {
        id = firebaseUser.uid
        if let name = firebaseUser.displayName, !name.isEmpty {
            displayName = name
        } else {
            displayName = firebaseUser.email ?? firebaseUser.uid
        }
        profileImageURL = firebaseUser.photoURL
    }
}
