//
//  Endpoint.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

enum Endpoint {
    case putUser
    case putDrive(user: User, session: DrivingSession)
    case getDrives

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
        case .putUser:
            return commonPath + "/user"
        case .putDrive:
            return commonPath + "/drive"
        case .getDrives:
            return commonPath + "/drives"
        }

    }

    var httpMethod: String {
        switch self {
        case .putUser,
             .putDrive:
            return "PUT"
        case .getDrives:
            return "GET"
        }
    }

    var body: Data? {
        switch self {
        case .putUser:
            let registerRequest = PutUserRequest()
            return try? DriveService.jsonEncoder.encode(registerRequest)

        case .putDrive(let user, let session):
            let saveDriveRequest = PutDriveRequest(user: user, session: session)
            return try? DriveService.jsonEncoder.encode(saveDriveRequest)
        case .getDrives:
            return nil
        }
    }

    var headerFieldProperties: [String: String] {
        switch self {
        case .putUser,
             .putDrive,
             .getDrives:
            return ["Content-Type": "Application/json"]
        }
    }
}
