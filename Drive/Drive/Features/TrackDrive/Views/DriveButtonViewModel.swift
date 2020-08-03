//
//  DriveButtonViewModel.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

struct DriveButtonViewModel {
    var title: String
    var backgroundColor: UIColor

    init(driveMode: DriveMode) {
        switch driveMode {
        case .start:
            title = "Start Drive"
            backgroundColor = .blue

        case .end:
            title = "End Drive"
            backgroundColor = .red
        }
    }
}
