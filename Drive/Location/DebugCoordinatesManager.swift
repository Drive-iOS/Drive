//
//  DebugCoordinatesProvider.swift
//  Drive
//
//  Created by Amanuel Ketebo on 10/3/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import MapKit

protocol DebugCoordinatesManagerDelegate: AnyObject {
    func debugCoordinatesManager(_ manager: DebugCoordinatesManager,
                                 didUpdateLocations locations: [CLLocation])
}

enum DebugCoordinatesSource {
    case charlottesville
    case rockville

    var filename: String {
        return "CvilleDebugCoordinates"
    }

    var extensionName: String {
        return "json"
    }
}

class DebugCoordinatesManager {
    // MARK: - Properties

    private let bundle: Bundle

    private let locationUpdateSecondsLimit = 5
    private var splitCoordinates: [[CLLocation]]?
    private var currentSplitCoordinatesIndex = 1
    private var timer: Timer?

    weak var delegate: DebugCoordinatesManagerDelegate?

    // MARK: - Init

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    // MARK: - Start updates

    func startReceivingLocationUpdates() {
        reset()
        guard let clLocations = parseDebugCoordinates(from: .charlottesville) else {
            return
        }

        startNotifyingLocationUpdates(with: clLocations)
    }

    private func parseDebugCoordinates(from source: DebugCoordinatesSource) -> [CLLocation]? {
        guard let coordinatesURL = bundle.url(forResource: source.filename, withExtension: source.extensionName),
              let debugCoordinatesData = try? Data(contentsOf: coordinatesURL) else {
            return nil
        }

        let singleDrive = try? DriveService.jsonDecoder.decode(GetCoordinatesResponse.self, from: debugCoordinatesData)

        return singleDrive?.results.map {
            CLLocation(latitude: CLLocationDegrees($0.latitude), longitude: CLLocationDegrees($0.longitude))
        }
    }

    // MARK: - Notify updates

    private func startNotifyingLocationUpdates(with debugCoordinates: [CLLocation]) {
        let chunkLength = debugCoordinates.count / locationUpdateSecondsLimit

        splitCoordinates = debugCoordinates.chunked(into: chunkLength)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }

            let currentIndex = self.currentSplitCoordinatesIndex
            let locations = self.splitCoordinates?[currentIndex] ?? []

            self.delegate?.debugCoordinatesManager(self, didUpdateLocations: locations)
            if self.currentSplitCoordinatesIndex == (self.locationUpdateSecondsLimit - 1) {
                self.reset()
            } else {
                self.currentSplitCoordinatesIndex += 1
            }
        })
    }

    // MARK: - Reset

    private func reset() {
        splitCoordinates = nil
        currentSplitCoordinatesIndex = 0
        timer?.invalidate()
        timer = nil
    }
}
