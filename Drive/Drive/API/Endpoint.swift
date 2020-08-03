//
//  Endpoint.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

enum Endpoint {
    case register

    var apiVersion: Int {
        return 1
    }

    var scheme: String {
        return "https"
    }

    var host: String {
        return "postgres-api-practice.herokuapp.com"
    }

    var path: String {
        switch self {
        case .register:
            return "/v\(apiVersion)/register"
        }
    }

    var httpMethod: String {
        switch self {
        case .register:
            return "PUT"
        }
    }
}
