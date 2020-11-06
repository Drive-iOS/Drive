//
//  GetCoordinatesResponse.swift
//  Drive
//
//  Created by Joshua Ramos on 11/5/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

struct GetCoordinateResponse: Decodable {
//    let driveID: String
//    let pointOrder: Int
    let longitude: Float
    let latitude: Float
    
    init(latitude: Float, longitude: Float) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    enum CodingKeys: String, CodingKey {
//        case driveID = "drive_id"
//        case pointOrder = "point_order"
        case longitude = "longitude"
        case latitude = "latitude"
    }
}

struct GetCoordinatesResponse: Decodable {
    let results: [GetCoordinateResponse]
}
