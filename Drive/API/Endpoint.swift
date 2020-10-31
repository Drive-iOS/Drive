//
//  Endpoint.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum Endpoint {
    case registerUser
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
        guard let host = bundle.object(forInfoDictionaryKey: "DriveServicePort") as? String else {
            return nil
        }

        return Int(host)
    }

    var path: String {
        let commonPath = "/v\(apiVersion)"

        switch self {
        case .registerUser:
            return commonPath + "/user"

        case .drive:
            return commonPath + "/drive"

        }
    }

    var httpMethod: String {
        switch self {
        case .registerUser,
             .drive:
            return "PUT"
        }
    }

    var body: Data? {
        switch self {
        case .registerUser:
            let registerRequest = RegisterRequest()
            return try? DriveService.jsonEncoder.encode(registerRequest)

        case .drive(let user, let session):
            let saveDriveRequest = SaveDriveRequest(user: user, session: session)
            return try? DriveService.jsonEncoder.encode(saveDriveRequest)
        }
    }

    var headerFieldProperties: [String: String] {
        switch self {
        case .registerUser,
            .drive:
            return ["Content-Type": "Application/json"]
        }
    }
}
