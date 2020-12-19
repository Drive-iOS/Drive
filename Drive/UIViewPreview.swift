//
//  UIViewPreview.swift
//  Drive
//
//  Created by Amanuel Ketebo on 12/2/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

// Blog post: https://nshipster.com/swiftui-previews/

import UIKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
