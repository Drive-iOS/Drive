//
//  DriveService.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum PutRequestResult {
    case success
    case failure(DriveServiceError)
}

enum DriveServiceError: Error {
    case invalidRequest
    case invalidResponse
    case savingFailed
    case invalidCurrentUser
}

struct DriveService: DriveServiceType {
    // MARK: - Properties
    static let urlSession = URLSession(configuration: .default)
    
    // Make sure Drive Service is not instantiable
    private init () {
        
    }

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
    typealias SaveDriveCompletion = (PutRequestResult) -> Void
    typealias GetDrivesCompletion = (Result<GetDrivesResponse, DriveServiceError>) -> Void

    // MARK: - Register

    static func register(completion: @escaping RegisterCompletion) {
        guard let request = RequestFactory.urlRequest(for: Endpoint.putUser) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let putUserResponse = try? JSONDecoder().decode(PutUserResponse.self, from: data) else {
                return completion(.failure(.invalidResponse))
            }

            let user = User(putUserResponse: putUserResponse)
            completion(.success(user))
        }

        dataTask.resume()
    }
    
    // MARK: - Get Drives
    
    static func getDrives(completion: @escaping GetDrivesCompletion) {
        guard let request = RequestFactory.urlRequest(for: Endpoint.getDrives) else {
            completion(.failure(.invalidRequest))
            return
        }

        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                return completion(.failure(.invalidResponse))
            }

            guard let allDrivesResponse = try? JSONDecoder().decode(GetDrivesResponse.self, from: data) else {
                return completion(.failure(.invalidResponse))
            }
            
            completion(.success(allDrivesResponse))
        }

        dataTask.resume()
    }
    
    // MARK: - Save Drive

    static func saveDrive(session: DrivingSession, completion: @escaping SaveDriveCompletion) {
        guard let user = UserProvider.shared.currentUser else {
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
