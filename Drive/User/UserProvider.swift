//
//  UserProvider.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/17/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum UserProviderError: Error {
    case missingLocalUser
    case failedRegisterRequest
}

class UserProvider {
    // MARK: - Properties
    static let shared = UserProvider()

    private enum Key: String {
        case userID
    }

    // Make sure User Provider is not instantiable
    private init () {
        guard let userID = userDefaults.string(forKey: Key.userID.rawValue) else {
            return
        }
        self.currentUser = User(id: userID)
    }

    var userDefaults = UserDefaults.standard

    var currentUser: User?

    func saveUser() {
        guard let currentUserID = currentUser?.id else {
            return
        }

        userDefaults.set(currentUserID, forKey: Key.userID.rawValue)
    }
}
