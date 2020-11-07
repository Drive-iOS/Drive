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
    typealias RequestCompletion<T> = (Result<T, DriveServiceError>) -> Void
    
    
    // MARK: - Register
    
    static private func makeEndpointRequest<T> (endpoint: Endpoint, model: T.Type, completion: @escaping RequestCompletion<T>) -> Void where T : Decodable {
        guard let request = RequestFactory.urlRequest(for: endpoint) else {
            completion(.failure(.invalidRequest))
            return
        }
        
        let dataTask = urlSession.dataTask(with: request) { data, _, _ in
            guard let data = data, let response = try? JSONDecoder().decode(model, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(response))
        }
        dataTask.resume()
    }
    
    
    static func register(completion: @escaping RequestCompletion<PutUserResponse>) -> Void {
        return makeEndpointRequest(endpoint: .putUser, model: PutUserResponse.self, completion: completion)
    }
    
    static func getDrives(completion: @escaping RequestCompletion<GetDrivesResponse>) -> Void {
        return makeEndpointRequest(endpoint: .getDrives, model: GetDrivesResponse.self, completion: completion)
    }
    
    static func saveDrive(session: DrivingSession, completion: @escaping RequestCompletion<PutDriveResponse>) -> Void {
        guard let user = UserProvider.shared.currentUser else {
            completion(.failure(.invalidCurrentUser))
            return
        }
        return makeEndpointRequest(endpoint: .putDrive(user: user, session: session), model: PutDriveResponse.self, completion: completion)
    }
}
