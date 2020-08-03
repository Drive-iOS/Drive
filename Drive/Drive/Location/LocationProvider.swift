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

class LocationProvider: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager
    weak var delegate: LocationProviderDelegate?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 0.01
    }

    func requestLocationPermissionsIfNeeded() {
        let locationAuthStatus = CLLocationManager.authorizationStatus()

        guard locationAuthStatus == .notDetermined else {
            return
        }

        locationManager.requestWhenInUseAuthorization()
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

        locationManager.startUpdatingLocation()
    }
}
