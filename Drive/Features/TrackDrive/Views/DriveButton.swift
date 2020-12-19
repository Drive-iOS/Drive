//
//  DriveButton.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

class DriveButton: UIButton {
    private enum Constants {
        static let cornerRadius: CGFloat = 10
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = Constants.cornerRadius
    }

    func update(withViewModel viewModel: DriveButtonViewModel) {
        setTitle(viewModel.title, for: .normal)
        backgroundColor = viewModel.backgroundColor
    }
}

// Blog post: https://nshipster.com/swiftui-previews/

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DriveButtonPreview: PreviewProvider {
    static var previews: some View {
        let completedViewModel = DriveButtonViewModel(driveState: .completed)
        let inProgressViewModel = DriveButtonViewModel(driveState: .inProgress)

        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            Group {
                UIViewPreview {
                    let driveButton = DriveButton()
                    driveButton.update(withViewModel: completedViewModel)
                    return driveButton
                }

                UIViewPreview {
                    let driveButton = DriveButton()
                    driveButton.update(withViewModel: inProgressViewModel)
                    return driveButton
                }
            }
            .previewLayout(.sizeThatFits)
            .padding(0)
            .environment(\.colorScheme, colorScheme)
            .previewDisplayName("\(colorScheme)")
        }
    }
}
#endif
