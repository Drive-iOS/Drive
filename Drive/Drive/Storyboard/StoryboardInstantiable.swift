//
//  StoryboardInstantiable.swift
//  Drive
//
//  Created by Amanuel Ketebo on 8/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    static var appStoryboard: Storyboard { get }
}

extension StoryboardInstantiable {
    static func fromStoryboard() -> Self {
        let storyboardToInitFrom = UIStoryboard(name: appStoryboard.filename, bundle: .main)
        let viewControllerIdentifier = String(describing: Self.self)

        // swiftlint:disable:next line_length
        guard let viewController = storyboardToInitFrom.instantiateViewController(identifier: viewControllerIdentifier) as? Self else {
            fatalError("Programmer error: Failed to create storyboard")
        }

        return viewController
    }
}
