//
//  User.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct User {
    // swiftlint:disable:next identifier_name
    var id: String

    init(registerResponse: RegisterResponse) {
        id = registerResponse.userID
    }
}
