//
//  ViewController.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/23/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

struct DrivingSession {
    var locations: [CLLocationCoordinate2D] = []
}

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

class DriveCoordinator: UIViewController, DriveDelegate, LocationProviderDelegate {
    @IBOutlet private var mapContainerView: UIView!
    @IBOutlet private var driveInfoContainerView: UIView!

    private var drivingSession: DrivingSession?
    private var mapVC: MapVC!
    private var driveVC: DriveVC!
    private var locationProvider = LocationProvider()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapVC()
        setUpDriveVC()
        setUpDrivingSession()
        setUpLocationProvider()
    }

    // MARK: - Set up

    private func setUpMapVC() {
        let mapVC = MapVC.fromStoryboard()

        mapContainerView.addSubview(mapVC.view)
        addChild(mapVC)
        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        mapVC.view.constrainToEdgesOfSuperView()
        self.mapVC = mapVC
    }

    private func setUpDriveVC() {
        let driveVC = DriveVC.fromStoryboard()

        driveInfoContainerView.addSubview(driveVC.view)
        addChild(driveVC)
        driveVC.view.translatesAutoresizingMaskIntoConstraints = false
        driveVC.view.constrainToEdgesOfSuperView()
        self.driveVC = driveVC
        driveVC.delegate = self
    }

    private func setUpDrivingSession() {
        drivingSession = DrivingSession()
    }

    private func setUpLocationProvider() {
        locationProvider.delegate = self
    }

    // MARK: - DriveDelegate

    func didUpdateDriveMode(_ driveMode: DriveMode) {
        // Maybe DriveMode can have more descriptive cases 🤔
        switch driveMode {
        case .start:
            saveDrive()
            drivingSession = DrivingSession()

        case .end:
            locationProvider.requestLocationPermissionsIfNeeded()
        }
    }

    private func saveDrive() {
        guard let drivingSession = drivingSession else {
            return
        }

        DriveService.shared.saveDrive(session: drivingSession) { result in
            switch result {
            case .success:
                print("success")

            case .failure:
                print("failed")
            }
        }
    }

    // MARK: - LocationProviderDelegate

    func didUpdateLocation(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        drivingSession?.locations.append(contentsOf: coordinates)
        mapVC.update(withLocations: locations)
    }
}
