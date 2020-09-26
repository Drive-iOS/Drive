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

    init(driveState: DriveState) {
        switch driveState {
        case .readyToStart:
            title = "Start Drive"
            backgroundColor = .blue

        case .inProgress:
            title = "End Drive"
            backgroundColor = .red

        case .completed:
            title = "Review Drive"
            backgroundColor = .green
        }
    }
}
