//
//  DriveServiceType.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

protocol DriveServiceType {
    var user: User? { get set }
    func register(completion: @escaping DriveService.RegisterCompletion)
}
