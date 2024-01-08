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
        return lowerBound...upperBound
    }
}

extension Range<Int> {
    var nsRange: NSRange {
        return NSRange(location: lowerBound, length: upperBound - lowerBound)
    }
}
