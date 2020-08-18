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
    private enum Key: String {
        case userID
    }

    var driveService = DriveService.shared
    var userDefaults = UserDefaults.standard

    /// Checks local drive service, then user defaults, and lastly creates
    /// a new user through a /register request to the drive API
    var currentUser: User? {
        if let currentUser = driveService.user {
            return currentUser
        } else if let userID = userDefaults.string(forKey: Key.userID.rawValue) {
            return User(id: userID)
        } else {
            return nil
        }
    }

    func createUser(completion: ((Result<User, UserProviderError>) -> Void)?) {
        driveService.register { result in
            switch result {
            case .success(let user):
                completion?(.success(user))

            case .failure:
                completion?(.failure(.failedRegisterRequest))
            }
        }
    }

    func saveUser() {
        guard let currentUserID = driveService.user?.id else {
            return
        }

        userDefaults.set(currentUserID, forKey: Key.userID.rawValue)
    }
}
