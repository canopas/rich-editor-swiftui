//
//  NSRange+Extension.swift
//
//
//  Created by Divyesh Vekariya on 11/12/23.
//

import Foundation

extension NSRange {
    var collapsed: Bool {
        return self.length == 0 || self.upperBound == self.lowerBound
    }
}
