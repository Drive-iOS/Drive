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

enum DebugCoordinatesSource {
    case cville
    case rockville

    var filename: String {
        return "CvilleDebugCoordinates"
    }

    var extensionName: String {
        return "json"
    }
}

class DebugCoordinatesManager {
    let bundle: Bundle
    var debugCoordinates: [SingleDriveCoordinate]?
    weak var delegate: DebugCoordinatesManagerDelegate?

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func startReceivingLocationUpdates() {
        guard let debugCoordinates = parseDebugCoordinates(from: .cville) else {
            return
        }

        self.debugCoordinates = debugCoordinates
        startNotifyingLocationUpdates(with: debugCoordinates)
    }

    func parseDebugCoordinates(from source: DebugCoordinatesSource) -> [SingleDriveCoordinate]? {
        guard let coordinatesURL = bundle.url(forResource: source.filename, withExtension: source.extensionName),
              let debugCoordinatesData = try? Data(contentsOf: coordinatesURL) else {
            return nil
        }

        return try? JSONDecoder().decode([SingleDriveCoordinate].self, from: debugCoordinatesData)
    }

    func startNotifyingLocationUpdates(with debugCoordinates: [SingleDriveCoordinate]) {
        // TODO: Create algorithm to split up debugCoordinates over a period of time
    }
}
