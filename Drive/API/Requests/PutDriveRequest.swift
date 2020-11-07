//
//  SaveDriveRequest.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/17/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct PutDriveRequest: Codable {
    let userID: String
    let startDate: Date
    let endDate: Date
    let coordinates: [PutCoordinateRequest]

    init(user: User, session: DrivingSession) {
        userID = user.id
        startDate = session.startDate
        endDate = session.endDate
        coordinates = session.locations.map {
            PutCoordinateRequest(longitude: $0.longitude, latitude: $0.latitude) }
    }

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case startDate = "start_time"
        case endDate = "end_time"
        case coordinates
    }
}
