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
    var startDate: Date
    var endDate = Date.distantPast
    var locations: [CLLocationCoordinate2D] = []
}

class DriveCoordinator: UIViewController, DriveDelegate, LocationProviderDelegate, StoryboardInstantiable {
    // MARK: - IBOutlets

    @IBOutlet private var mapContainerView: UIView!
    @IBOutlet private var driveInfoContainerView: UIView!
    @IBOutlet private var driveInfoContainerViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private var drivingSession: DrivingSession?
    private var isFirstLocationOfDrive = true
    private var mapVC: MapVC!
    private var driveVC: DriveVC!
    private var slidingCardManager: SlidingCardManager!
    private var locationProvider = LocationProvider(locationSource: .debug(DebugCoordinatesManager()))

    static var appStoryboard: Storyboard {
        return .trackDrive
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapVC()
        setUpDriveVC()
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
        slidingCardManager = SlidingCardManager(slidingViewController: driveVC,
                                                  containerViewController: self)
        slidingCardManager.setUp()
        self.driveVC = driveVC
        driveVC.delegate = self
    }

    private func setUpLocationProvider() {
        locationProvider.delegate = self
    }

    // MARK: - DriveDelegate

    func didUpdate(_ driveState: DriveState) {
        switch driveState {
        case .readyToStart:
            isFirstLocationOfDrive = true

        case .inProgress:
            drivingSession = DrivingSession(startDate: Date())
            locationProvider.startReceivingLocationUpdates()

        case .completed:
            drivingSession?.endDate = Date()
            saveDrive()
            showDriveTrail()
            drivingSession = nil
        }
    }

    private func showDriveTrail() {
        guard let drivingSession = drivingSession else {
            return
        }

        mapVC.showDriveTrail(with: drivingSession,
                             shouldTransitionToRegion: isFirstLocationOfDrive)
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

    func updateDriveInfoContainerViewHeight(with height: CGFloat) {
        driveInfoContainerViewHeightConstraint.constant = height
    }

    // MARK: - LocationProviderDelegate

    func didUpdateLocation(locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        drivingSession?.locations.append(contentsOf: coordinates)
        showDriveTrail()
        isFirstLocationOfDrive = false
    }
}
