//
//  ViewController.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/23/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

class DriveCoordinator: UIViewController, DriveDelegate, LocationProviderDelegate {
    @IBOutlet private var mapContainerView: UIView!
    @IBOutlet private var driveInfoContainerView: UIView!

    private var mapVC: MapVC!
    private var driveVC: DriveVC!
    private var locationProvider = LocationProvider()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapVC()
        setUpDriveVC()
        locationProvider.delegate = self
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

    func setUpDriveVC() {
        let driveVC = DriveVC.fromStoryboard()

        driveInfoContainerView.addSubview(driveVC.view)
        addChild(driveVC)
        driveVC.view.translatesAutoresizingMaskIntoConstraints = false
        driveVC.view.constrainToEdgesOfSuperView()
        self.driveVC = driveVC
        driveVC.delegate = self
    }

    // MARK: - DriveDelegate

    func didUpdateDriveMode(_ driveMode: DriveMode) {
        guard driveMode == .end else {
            return
        }

        locationProvider.requestLocationPermissionsIfNeeded()
    }

    // MARK: - LocationProviderDelegate

    func didUpdateLocation(locations: [CLLocation]) {
        mapVC.update(withLocations: locations)
    }
}
