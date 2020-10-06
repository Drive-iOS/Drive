//
//  DriveResponse.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct SingleDriveCoordinate: Decodable {
    let longitude: Double
    let latitude: Double
}

struct SingleDriveResponse: Decodable {
    let startDate: Date
    let endDate: Date
    let coordinates: [SingleDriveCoordinate]
}
