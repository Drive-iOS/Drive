//
//  Storyboard.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

enum Storyboard {
    case main
    case trackDrive

    var filename: String {
        switch self {
        case .main:
            return "Main"

        case .trackDrive:
            return "TrackDrive"
        }
    }
}
