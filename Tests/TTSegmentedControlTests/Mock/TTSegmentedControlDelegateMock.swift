//
//  TTSegmentedControlDelegateMock.swift
//  TTSegmentedControlTests
//
//  Created by Igor Dumitru on 09.02.2023.
//

import Foundation
import TTSegmentedControl

final class TTSegmentedControlDelegateMock {
    private(set) var segmentedViewDidBeginCalled = false
    private(set) var segmentedViewdidDragAtIndexCalled = false
    private(set) var segmentedViewDidEndAtIndexCalled = false
}

extension TTSegmentedControlDelegateMock: TTSegmentedControlDelegate {
    func segmentedViewDidBegin(_ view: TTSegmentedControl) {
        segmentedViewDidBeginCalled = true
    }
    
    func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int) {
        segmentedViewdidDragAtIndexCalled = true
    }
    
    func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int) {
        segmentedViewDidEndAtIndexCalled = true
    }
}

extension TTSegmentedControlDelegateMock {
    func reset() {
        segmentedViewDidBeginCalled = false
        segmentedViewdidDragAtIndexCalled = false
        segmentedViewDidEndAtIndexCalled = false
    }
}
