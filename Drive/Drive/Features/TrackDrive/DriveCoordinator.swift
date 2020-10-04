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

class DriveCoordinator: UIViewController, DriveDelegate, LocationProviderDelegate {
    @IBOutlet private var mapContainerView: UIView!
    @IBOutlet private var driveInfoContainerView: UIView!

    private var drivingSession: DrivingSession?
    private var mapVC: MapVC!
    private var driveVC: DriveVC!
    private var locationProvider = LocationProvider(locationSource: .debug(DebugCoordinatesManager()))

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

    func didUpdate(_ driveState: DriveState) {
        switch driveState {
        case .readyToStart:
            break

        case .inProgress:
            locationProvider.startReceivingLocationUpdates()

        case .completed:
            saveDrive()
            showDriveTrail()
            drivingSession = DrivingSession()
        }
    }

    private func showDriveTrail() {
        guard let drivingSession = drivingSession else {
            return
        }

        mapVC.showDriveTrail(with: drivingSession)
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
        showDriveTrail()
    }
}
