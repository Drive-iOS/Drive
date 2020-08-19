//
//  SaveDriveRequest.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/17/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct SaveDriveCoordinate: Codable {
    let longitude: Double
    let latitude: Double
}

struct SaveDriveRequest: Codable {
    let userID: String
    let coordinates: [SaveDriveCoordinate]

    init(user: User, session: DrivingSession) {
        userID = user.id
        coordinates = session.locations.map { SaveDriveCoordinate(longitude: $0.longitude, latitude: $0.latitude) }
    }
}
