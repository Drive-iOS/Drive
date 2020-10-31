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
    // MARK: - IBOutlets

    @IBOutlet private var driveButton: DriveButton!

    // MARK: - Properties

    weak var delegate: DriveDelegate?

    private var currentDriveState: DriveState = .readyToStart

    static var appStoryboard: Storyboard {
        return .trackDrive
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStartDriveButton()
    }

    // MARK: - Set Up

    private func setUpStartDriveButton() {
        updateButton(withDriveState: currentDriveState)
    }

    // MARK: - Updating UI

    @IBAction func tappedDriveButton(_ sender: UIButton) {
        let updatedDriveState: DriveState

        switch currentDriveState {
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
        self.currentDriveState = driveState
        driveButton.update(withViewModel: DriveButtonViewModel(driveState: driveState))
        delegate?.didUpdate(driveState)
    }
}
