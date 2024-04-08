//
//  NSRange+Extension.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation

extension NSRange {
    var isCollapsed: Bool {
        return self.length == 0 || self.upperBound == self.lowerBound
    }
    
    var closedRange: ClosedRange<Int> {
        return lowerBound...(upperBound - (length > 0 ? 1 : 0))
    }
}

extension ClosedRange<Int> {
    var nsRange: NSRange {
        return NSRange(location: lowerBound, length: upperBound - lowerBound)
    }

    func isInRange(_ range: ClosedRange<Int>) -> Bool {
        return range.contains(self.lowerBound) && range.contains(self.upperBound)
    }
    
    func isPartialOverlap(_ range: ClosedRange<Int>) -> Bool {
        return self.contains(range.lowerBound) != self.contains(range.upperBound)
    }

    func isSameAs(_ range: ClosedRange<Int>) -> Bool {
        return (self.lowerBound == range.lowerBound) && (self.upperBound == range.upperBound)
    }
}

extension Range<Int> {
    var nsRange: NSRange {
        return NSRange(location: lowerBound, length: upperBound - lowerBound)
    }
}
