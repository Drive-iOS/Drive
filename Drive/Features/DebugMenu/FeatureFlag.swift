//
//  FeatureFlag.swift
//  Drive
//
//  Created by Amanuel Ketebo on 11/14/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import SwiftUI
import Combine

class FeatureFlag: ObservableObject {
    @Published var isEnabled: Bool
    var description: String

    init(isEnabled: Bool,
         description: String) {
        self.isEnabled = isEnabled
        self.description = description
    }
}

// TODO: (Aman Ketebo) Simple feature flag for now but in the future we'll want:
//       1. A way to update this remotely
//       2. Have it persistent across launches
class FeatureFlags {
    static let all: [FeatureFlag] = [shouldUseDebugCoordinates]

    static let shouldUseDebugCoordinates = FeatureFlag(isEnabled: false,
                                                       description: "Enable using debug coordinates")
}
