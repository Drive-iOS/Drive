//
//  MapVC.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, StoryboardInstantiable {
    @IBOutlet private var mapView: MKMapView!

    static var appStoryboard: Storyboard {
        return .main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(withLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
