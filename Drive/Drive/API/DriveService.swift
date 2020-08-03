//
//  DriveService.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum DriveServiceError: Error {
    case invalidRequest
    case invalidResponse
}

class DriveService: DriveServiceType {

    // MARK: - Properties

    var user: User?
    let urlSession = URLSession(configuration: .default)

    // MARK: - Type Aliases

    typealias RegisterCompletion = (Result<User, DriveServiceError>) -> Void

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
}
