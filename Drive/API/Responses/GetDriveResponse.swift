//
//  DriveResponse.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct GetDriveReponse: Decodable {
    let drive_id: String
    let user_id: String
    let start_time: String
    let end_time: String
}
