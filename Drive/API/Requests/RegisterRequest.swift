//
//  RegisterRequest.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/17/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct RegisterRequest: Codable {
    var firstName: String?
    var lastName: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
    }
}
