//
//  MapVC.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, StoryboardInstantiable, MKMapViewDelegate {
    // MARK: - IBOutlets

    @IBOutlet private var mapView: MKMapView!

    // MARK: - Properties

    static var appStoryboard: Storyboard {
        return .main
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
    }

    // MARK: - Set Up

    private func setUpMapView() {
        mapView.delegate = self
    }

    // MARK: - Updating

    func update(with currentLocation: CLLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func showDriveTrail(with drivingSession: DrivingSession) {
        let driveTrailOverlay = DriveTrailOverlay(coordinates: drivingSession.locations,
                                        count: drivingSession.locations.count)
        removeDriveTrailOverlays()
        mapView.addOverlay(driveTrailOverlay)
    }

    private func removeDriveTrailOverlays() {
        mapView.overlays.forEach { overlay in
            if overlay is DriveTrailOverlay {
                mapView.removeOverlay(overlay)
            }
        }
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let driveTrailOverlay = overlay as? DriveTrailOverlay else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolylineRenderer(overlay: driveTrailOverlay)

        renderer.strokeColor = driveTrailOverlay.visualProperties.color
        renderer.lineWidth = driveTrailOverlay.visualProperties.width

        return renderer
    }
}
