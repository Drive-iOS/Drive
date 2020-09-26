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

enum LocationDataSource {
    case device
    case debug
}

class LocationProvider: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    let locationDataSource: LocationDataSource
    weak var delegate: LocationProviderDelegate?

    init(locationDataSource: LocationDataSource = .device) {
        switch locationDataSource {
        case .device:
            locationManager = CLLocationManager()

        case .debug:
            locationManager = nil
        }

        self.locationDataSource = locationDataSource
        super.init()
        locationManager?.delegate = self
    }

    func requestLocationPermissionsIfNeeded() {
        let locationAuthStatus = CLLocationManager.authorizationStatus()

        guard locationAuthStatus == .notDetermined else {
            return
        }

        locationManager?.requestAlwaysAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(locations: locations)
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager?.startUpdatingLocation()
    }
}
