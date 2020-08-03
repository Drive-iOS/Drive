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
