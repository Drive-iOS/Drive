//
//  Endpoint.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum Endpoint {
    case register
    case drive(user: User, session: DrivingSession)

    var apiVersion: Int {
        return 1
    }

    func scheme(using bundle: Bundle) -> String {
        guard let scheme = bundle.object(forInfoDictionaryKey: "DriveServiceScheme") as? String else {
            fatalError("Expected DriveServiceScheme to exist")
        }

        return scheme
    }

    func host(using bundle: Bundle) -> String {
        guard let host = bundle.object(forInfoDictionaryKey: "DriveServiceDomain") as? String else {
            fatalError("Expected DriveServiceDomain to exist")
        }

        return host
    }

    func port(using bundle: Bundle) -> Int? {
        guard let host = bundle.object(forInfoDictionaryKey: "DriveServicePort") as? String,
              !host.isEmpty else {
            return nil
        }

        return Int(host)
    }

    var path: String {
        let commonPath = "/v\(apiVersion)"

        switch self {
        case .register:
            return commonPath + "/register"

        case .drive:
            return commonPath + "/drive"

        }
    }

    var httpMethod: String {
        switch self {
        case .register,
             .drive:
            return "PUT"
        }
    }

    var body: Data? {
        switch self {
        case .register:
            let registerRequest = RegisterRequest()
            return try? JSONEncoder().encode(registerRequest)

        case .drive(let user, let session):
            let saveDriveRequest = SaveDriveRequest(user: user, session: session)
            return try? JSONEncoder().encode(saveDriveRequest)
        }
    }

    var headerFieldProperties: [String: String] {
        switch self {
        case .register,
            .drive:
            return ["Content-Type": "Application/json"]
        }
    }
}
