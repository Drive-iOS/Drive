//
//  AppDelegate.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/23/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import CoreData

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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var userProvider = UserProvider()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpUser()
        return true
    }

    private func setUpUser() {
        if let currentUser = userProvider.currentUser {
            userProvider.driveService.user = currentUser
        } else {
            createNewUser()
        }
    }

    private func createNewUser() {
        userProvider.createUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.userProvider.driveService.user = user
                self?.userProvider.saveUser()

            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be
        // called shortly after application:didFinishLaunchingWithOptions. Use this method to
        // release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Drive")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may
                // be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection
                   when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it
                // may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
