//
//  RequestFactory.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct RequestFactory {
    static func urlRequest(for endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path

        guard let url = components.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.httpBody = endpoint.body
        endpoint.headerFieldProperties.forEach { (headerKey, headerProperty) in
            request.setValue(headerProperty, forHTTPHeaderField: headerKey)
        }

        return request
    }
}
