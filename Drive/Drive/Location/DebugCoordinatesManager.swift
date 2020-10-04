//
//  DebugCoordinatesProvider.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/3/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import MapKit

protocol DebugCoordinatesManagerDelegate: AnyObject {
    func debugCoordinatesProvider(_ provider: DebugCoordinatesManager,
                                  didUpdateLocations locations: [CLLocation])
}

class DebugCoordinatesManager {
    weak var delegate: DebugCoordinatesManagerDelegate?

    func startReceivingLocationUpdates() {
        // TODO
    }
}
