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

    static var jsonDecoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }

    static var jsonEncoder: JSONEncoder {
        let jsonDecoder = JSONEncoder()
        jsonDecoder.dateEncodingStrategy = .iso8601
        return jsonDecoder
    }

    // MARK: - Type Aliases

    typealias RegisterCompletion = (Result<User, DriveServiceError>) -> Void
    typealias SaveDriveCompletion = (SaveDriveResult) -> Void
    typealias getDrivesCompletion = (GetDrivesResponse?) -> Void

    // MARK: - Register

    func register(completion: @escaping RegisterCompletion) {
        let endpoint = Endpoint.putUser

        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let registerResponse = try? JSONDecoder().decode(PutUserResponse.self, from: data) else {
                return completion(.failure(.invalidResponse))
            }

            let user = User(registerResponse: registerResponse)
            completion(.success(user))
        }

        dataTask.resume()
    }
    
    func getDrives(completion: @escaping getDrivesCompletion) {
        guard let user = user else {
            completion(nil)
            return
        }

        let endpoint = Endpoint.getDrives(user: user)

        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(nil)
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(nil)
            }

            guard let allDrivesResponse = try? JSONDecoder().decode(GetDrivesResponse.self, from: data) else {
                return completion(nil)
            }
            
            completion(allDrivesResponse)
        }

        dataTask.resume()
    }

    func saveDrive(session: DrivingSession, completion: @escaping SaveDriveCompletion) {
        guard let user = user else {
            completion(.failure(.invalidCurrentUser))
            return
        }

        let endpoint = Endpoint.putDrive(user: user, session: session)

        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let saveDriveResponse = try? JSONDecoder().decode(PutDriveResponse.self, from: data) else {
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
