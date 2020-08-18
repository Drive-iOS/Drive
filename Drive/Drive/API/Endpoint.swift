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

    var scheme: String {
        return "https"
    }

    var host: String {
        return "drive-heroku-api.herokuapp.com"
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
