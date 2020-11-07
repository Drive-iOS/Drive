//
//  SlidingCardManagerViewController.swift
//  Drive
//
//  Created by Amanuel Ketebo on 11/6/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

protocol SlidingCardViewController: UIViewController {
    var fullHeight: CGFloat { get }
    var partialHeight: CGFloat { get }
    var almostHiddenHeight: CGFloat { get }
}

class SlidingCardManager {
    var slidingViewController: SlidingCardViewController
    var containerViewController: UIViewController
    var initialOrigin = CGPoint.zero

    init(slidingViewController: SlidingCardViewController,
         containerViewController: UIViewController) {
        self.slidingViewController = slidingViewController
        self.containerViewController = containerViewController
    }

    func setUp() {
        containerViewController.view.addSubview(slidingViewController.view)
        containerViewController.addChild(slidingViewController)

        // Set up view
        slidingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slidingViewController.view.leftAnchor.constraint(equalTo: containerViewController.view.leftAnchor),
            slidingViewController.view.rightAnchor.constraint(equalTo: containerViewController.view.rightAnchor),
            containerViewController.view.bottomAnchor.constraint(equalTo: slidingViewController.view.topAnchor,
                                                                 constant: slidingViewController.partialHeight),
            slidingViewController.view.heightAnchor.constraint(equalToConstant: slidingViewController.fullHeight),
            slidingViewController.view.heightAnchor.constraint(equalToConstant: slidingViewController.fullHeight)
        ])

        // Set up sliding
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(handlePanGesture(_:)))
        self.slidingViewController.view.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            initialOrigin = slidingViewController.view.frame.origin

        case .changed:
            // swiftlint:disable line_length
            let yTranslation = gestureRecognizer.translation(in: containerViewController.view).y
            let updatedY = initialOrigin.y + yTranslation
            let isNotTooHigh = updatedY + slidingViewController.fullHeight >= containerViewController.view.bounds.height
            let isNotTooLow = containerViewController.view.bounds.height - updatedY >= slidingViewController.almostHiddenHeight
            let shouldUpdateY = isNotTooLow && isNotTooHigh

            guard shouldUpdateY else {
                return
            }

            slidingViewController.view.frame.origin.y = updatedY
            // swiftlint:enable line_length

        case .possible,
             .cancelled,
             .failed,
             .ended:
            break

        @unknown default:
            break
        }
    }
}
