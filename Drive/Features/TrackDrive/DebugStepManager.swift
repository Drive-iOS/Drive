//
//  DebugStepManager.swift
//  Drive
//
//  Created by Amanuel Ketebo on 11/14/20.
//  Copyright © 2020 com.amanjosh. All rights reserved.
//

import Foundation

protocol DebugStepManagerDelegate: AnyObject {
    // swiftlint:disable:next identifier_name
    func didReach(expectedCount: Int, in: TimeInterval)
}

class DebugStepManager {
    // MARK: - Properties

    weak var delegate: DebugStepManagerDelegate?

    private var currentCount = 0
    private let expectedCount: Int
    private let limitInSeconds: TimeInterval
    private var timer: Timer?

    // MARK: - Init

    init(expectedCount: Int, limitInSeconds: TimeInterval) {
        self.expectedCount = expectedCount
        self.limitInSeconds = limitInSeconds
    }

    // MARK: - Updating Count

    func incrementCount() {
        currentCount += 1

        guard currentCount < expectedCount else {
            notifyDelegateAndReset()
            return
        }

        setUpTimer()
    }

    // MARK: - Updating Timer and Delegate

    private func setUpTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: limitInSeconds, repeats: false) { [weak self] _ in
            defer {
                self?.reset()
            }

            guard self?.currentCount == self?.expectedCount else {
                return
            }

            self?.notifyDelegateAndReset()
        }
    }

    private func notifyDelegateAndReset() {
        self.delegate?.didReach(expectedCount: expectedCount, in: limitInSeconds)
        reset()
    }

    private func reset() {
        currentCount = 0
        timer?.invalidate()
        timer = nil
    }
}
