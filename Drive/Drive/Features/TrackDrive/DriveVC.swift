//
//  DriveInfoVC.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit
import MapKit

enum DriveMode: Equatable {
    case start
    case end
}

protocol DriveDelegate: AnyObject {
    func didUpdateDriveMode(_ driveMode: DriveMode)
}

class DriveVC: UIViewController, StoryboardInstantiable {
    @IBOutlet private var driveButton: DriveButton!

    weak var delegate: DriveDelegate?

    private var driveMode: DriveMode = .start

    static var appStoryboard: Storyboard {
        return .main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStartDriveButton()
    }

    private func setupStartDriveButton() {
        updateButton(withDriveMode: driveMode)
    }

    @IBAction func tappedDriveButton(_ sender: UIButton) {
        let updatedDriveMode: DriveMode

        switch driveMode {
        case .start:
            updatedDriveMode = .end

        case .end:
            updatedDriveMode = .start
        }

        updateButton(withDriveMode: updatedDriveMode)
    }

    private func updateButton(withDriveMode driveMode: DriveMode) {
        self.driveMode = driveMode
        driveButton.update(withViewModel: DriveButtonViewModel(driveMode: driveMode))
        delegate?.didUpdateDriveMode(driveMode)
    }
}
