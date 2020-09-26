//
//  DriveInfoVC.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

enum DriveState: Equatable {
    case readyToStart
    case inProgress
    case completed
}

protocol DriveDelegate: AnyObject {
    func didUpdate(_ driveState: DriveState)
}

class DriveVC: UIViewController, StoryboardInstantiable {
    @IBOutlet private var driveButton: DriveButton!

    weak var delegate: DriveDelegate?

    private var driveState: DriveState = .readyToStart

    static var appStoryboard: Storyboard {
        return .main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartDriveButton()
    }

    private func setupStartDriveButton() {
        updateButton(withDriveState: driveState)
    }

    @IBAction func tappedDriveButton(_ sender: UIButton) {
        let updatedDriveState: DriveState

        switch driveState {
        case .readyToStart:
            updatedDriveState = .inProgress

        case .inProgress:
            updatedDriveState = .completed

        case .completed:
            updatedDriveState = .readyToStart
        }

        updateButton(withDriveState: updatedDriveState)
    }
    

    private func updateButton(withDriveState driveState: DriveState) {
        self.driveState = driveState
        driveButton.update(withViewModel: DriveButtonViewModel(driveState: driveState))
        delegate?.didUpdateDriveMode(driveState)
    }
}
