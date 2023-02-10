//
//  DelayedWorkItem.swift
//  TTSegmentedControl
//
//  Created by Igor Dumitru on 31.01.2023.
//

import Foundation

final class DelayedWorkItem: NSObject {
    let delay: Double
    let body: () -> Void

    init(
        delay: Double,
        body: @escaping () -> Void
    ) {
        self.delay = delay
        self.body = body
    }
}

extension DelayedWorkItem {
    func execute() {
        perform(#selector(executeCodeFromBody), with: nil, afterDelay: delay)
    }

    func cancel() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}

private extension DelayedWorkItem {
    @objc func executeCodeFromBody() {
        body()
    }
}
