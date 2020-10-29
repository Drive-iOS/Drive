//
//  UIViewExtension.swift
//  Drive
//
//  Created by Amanuel Ketebo on 7/25/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

extension UIView {
    func constrainToEdgesOfSuperView() {
        guard let superview = superview else {
            return
        }

        self.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
    }
}
