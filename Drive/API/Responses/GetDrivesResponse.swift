//
//  DrivesResponse.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct GetDriveReponse: Decodable {
    let userID: String
    let driveID: String
    let startTime: String
    let endTime: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case driveID = "drive_id"
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

struct GetDrivesResponse: Decodable {
    let results: [GetDriveReponse]
}
