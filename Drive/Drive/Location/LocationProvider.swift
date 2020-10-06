//
//  LocationProvider.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import MapKit

protocol LocationProviderDelegate: AnyObject {
    func didUpdateLocation(locations: [CLLocation])
}

enum LocationSource {
    case device(CLLocationManager)
    case debug(DebugCoordinatesManager)
}

class LocationProvider: NSObject, CLLocationManagerDelegate, DebugCoordinatesManagerDelegate {
    private enum Constants {
        static let distanceInMetersBetweenLocationUpdates: Double = 20
    }

    let locationSource: LocationSource
    weak var delegate: LocationProviderDelegate?

    init(locationSource: LocationSource) {
        self.locationSource = locationSource
        super.init()

        switch locationSource {
        case .device(let locationManager):
            locationManager.distanceFilter = Constants.distanceInMetersBetweenLocationUpdates
            locationManager.delegate = self

        case .debug(let debugCoordinatesManager):
            debugCoordinatesManager.delegate = self
        }
    }

    func startReceivingLocationUpdates() {
        switch locationSource {
        case .device:
            requestLocationPermissionsIfNeeded()

        case .debug(let debugCoordinatesManager):
            debugCoordinatesManager.startReceivingLocationUpdates()
        }
    }

    func requestLocationPermissionsIfNeeded() {
        guard case .device(let locationManager) = locationSource else {
            return
        }

        let locationAuthStatus = CLLocationManager.authorizationStatus()

        guard locationAuthStatus == .notDetermined else {
            return
        }

        locationManager.requestAlwaysAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(locations: locations)
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse,
              case .device(let locationManager) = locationSource else {
            return
        }

        locationManager.startUpdatingLocation()
    }

    // MARK: - DebugCoordinatesManagerDelegate

    func debugCoordinatesManager(_ manager: DebugCoordinatesManager,
                                 didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(locations: locations)
    }
}
