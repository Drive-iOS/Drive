//
//  DriveOverlay.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/18/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import MapKit

struct VisualProperties {
    var color = UIColor.black
    var width: CGFloat = 3
}

class DriveTrailOverlay: MKPolyline {
    var visualProperties = VisualProperties()
}
