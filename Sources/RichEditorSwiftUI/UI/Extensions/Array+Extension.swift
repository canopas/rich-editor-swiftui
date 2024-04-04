//
//  Array+Extension.swift
//
//
//  Created by Divyesh Vekariya on 04/04/24.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
