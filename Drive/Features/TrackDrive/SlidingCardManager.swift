//
//  SlidingCardManagerViewController.swift
//  Drive
//
//  Created by Amanuel Ketebo on 11/6/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import UIKit

protocol SlidingCardViewController: UIViewController {
    var fullPosition: SlidingCardManager.Position { get }
    var partialPosition: SlidingCardManager.Position { get }
    var hiddenPosition: SlidingCardManager.Position { get }
}

class SlidingCardManager {
    enum Direction {
        // TODO: (Aman Ketebo) Create .swiftlint.yml file so we can
        // remove warnings for issues like `identifier_name`

        // swiftlint:disable:next identifier_name
        case up
        case down
    }

    enum Position {
        case full(CGFloat)
        case partial(CGFloat)
        case hidden(CGFloat)

        var value: CGFloat {
            switch self {
            case .full(let position),
                 .partial(let position),
                 .hidden(let position):
                return position
            }
        }

        func nextPosition(for slidingCardViewController: SlidingCardViewController,
                          in direction: Direction) -> Position {
            switch (direction, self) {
            case (.up, .full),
                 (.up, .partial):
                return slidingCardViewController.fullPosition

            case (.up, .hidden),
                 (.down, .full):
                return slidingCardViewController.partialPosition

            case (.down, .partial),
                 (.down, .hidden):
                return slidingCardViewController.hiddenPosition
            }
        }
    }

    private var slidingViewController: SlidingCardViewController
    private var containerViewController: UIViewController
    private var currentStartingOrigin = CGPoint.zero
    private var currentSlidePosition = Position.full(.zero)

    init(slidingViewController: SlidingCardViewController,
         containerViewController: UIViewController) {
        self.slidingViewController = slidingViewController
        self.containerViewController = containerViewController
    }

    func setUp(withPosition position: Position) {
        currentSlidePosition = position
        containerViewController.view.addSubview(slidingViewController.view)
        containerViewController.addChild(slidingViewController)

        // Set up view
        // swiftlint:disable line_length
        slidingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slidingViewController.view.leftAnchor.constraint(equalTo: containerViewController.view.leftAnchor),
            slidingViewController.view.rightAnchor.constraint(equalTo: containerViewController.view.rightAnchor),
            slidingViewController.view.heightAnchor.constraint(equalToConstant: slidingViewController.fullPosition.value),
            containerViewController.view.bottomAnchor.constraint(equalTo: slidingViewController.view.topAnchor,
                                                                 constant: position.value)
        ])

        // Set up sliding
        let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                       action: #selector(handlePanGesture(_:)))
        self.slidingViewController.view.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            currentStartingOrigin = slidingViewController.view.frame.origin

        case .changed:
            let yTranslation = gestureRecognizer.translation(in: containerViewController.view).y
            let updatedY = currentStartingOrigin.y + yTranslation
            let isNotTooHigh = updatedY + slidingViewController.fullPosition.value >= containerViewController.view.bounds.height
            let isNotTooLow = containerViewController.view.bounds.height - updatedY >= slidingViewController.hiddenPosition.value
            let shouldUpdateY = isNotTooLow && isNotTooHigh

            guard shouldUpdateY else {
                return
            }

            slidingViewController.view.frame.origin.y = updatedY

        case .possible,
             .cancelled,
             .failed:
            break

        case .ended:
            let yTranslation = gestureRecognizer.translation(in: containerViewController.view).y
            let yVelocity = gestureRecognizer.velocity(in: containerViewController.view).y
            let isSlidingUp = yTranslation <= 0
            let isLongEnough = abs(yTranslation) > 20
            let isFastEnough = abs(yVelocity) > 100
            let shouldUpdateSlidePosition = isLongEnough || isFastEnough

            guard shouldUpdateSlidePosition else {
                slidingViewController.view.frame.origin.y = containerViewController.view.bounds.height - currentSlidePosition.value
                return
            }

            updateSlidePosition(for: isSlidingUp ? .up : .down)

        @unknown default:
            break
        }
    }

    private func updateSlidePosition(for direction: Direction) {
        let updatedSlidePosition = currentSlidePosition.nextPosition(for: slidingViewController, in: direction)

        UIView.animate(withDuration: 0.2, animations: {
            self.slidingViewController.view.frame.origin.y = self.containerViewController.view.bounds.height - updatedSlidePosition.value
        })

        // swiftlint:enable line_length
        currentSlidePosition = updatedSlidePosition
    }
}
