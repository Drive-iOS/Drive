//
//  DriveServiceType.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

protocol DriveServiceType {
    static func register(completion: @escaping DriveService.RegisterCompletion)
    static func getDrives(completion: @escaping DriveService.GetDrivesCompletion)
    static func saveDrive(session: DrivingSession, completion: @escaping DriveService.SaveDriveCompletion)
}
