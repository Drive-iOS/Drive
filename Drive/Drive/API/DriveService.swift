//
//  DriveService.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum SaveDriveResult {
    case success
    case failure(DriveServiceError)
}

enum DriveServiceError: Error {
    case invalidRequest
    case invalidResponse
    case savingFailed
    case invalidCurrentUser
}

class DriveService: DriveServiceType {

    // MARK: - Properties

    static let shared = DriveService()

    var user: User?
    let urlSession = URLSession(configuration: .default)

    // MARK: - Type Aliases

    typealias RegisterCompletion = (Result<User, DriveServiceError>) -> Void
    typealias SaveDriveCompletion = (SaveDriveResult) -> Void

    // MARK: - Register

    func register(completion: @escaping RegisterCompletion) {
        let endpoint = Endpoint.register

        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
                return completion(.failure(.invalidResponse))
            }

            let user = User(registerResponse: registerResponse)
            completion(.success(user))
        }

        dataTask.resume()
    }

    func saveDrive(session: DrivingSession, completion: @escaping SaveDriveCompletion) {
        guard let user = user else {
            completion(.failure(.invalidCurrentUser))
            return
        }

        let endpoint = Endpoint.drive(user: user, session: session)

        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let saveDriveResponse = try? JSONDecoder().decode(SaveDriveResponse.self, from: data) else {
                return completion(.failure(.invalidResponse))
            }

            if saveDriveResponse.success {
                completion(.success)
            } else {
                completion(.failure(.savingFailed))
            }
        }

        dataTask.resume()
    }
}
