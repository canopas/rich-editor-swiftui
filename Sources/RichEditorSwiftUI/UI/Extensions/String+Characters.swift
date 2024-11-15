//
//  String+Characters.swift
//
//
//  Created by Divyesh Vekariya on 01/01/24.
//

import Foundation

internal extension String.Element {

    /// Get the string element for a `\r` carriage return.
    static var carriageReturn: String.Element { "\r" }
    
    /// Get the string element for a `\n` newline.
    static var newLine: String.Element { "\n" }
    
    /// Get the string element for a `\t` tab.
    static var tab: String.Element { "\t" }
    
    /// Get the string element for a ` ` space.
    static var space: String.Element { " " }
}


internal extension String {
    
    /// Get the string for a `\r` carriage return.
    static let carriageReturn = String(.carriageReturn)
    
    /// Get the string for a `\n` newline.
    static let newLine = String(.newLine)
    
    /// Get the string for a `\t` tab.
    static let tab = String(.tab)
    
    /// Get the string for a ` ` space.
    static let space = String(.space)
}

internal extension String {
    func getHeaderRangeFor(_ range: NSRange) -> NSRange {
        let text = self
        guard !text.isEmpty else { return range }

        let fromIndex = range.lowerBound
        let toIndex = range.isCollapsed ? fromIndex : range.upperBound

        let newLineStartIndex = text.utf16.prefix(fromIndex).map({ $0 }).lastIndex(of: "\n".utf16.last) ?? 0
        let newLineEndIndex = text.utf16.suffix(from: text.utf16.index(text.utf16.startIndex, offsetBy: max(0, toIndex - 1))).map({ $0 }).firstIndex(of: "\n".utf16.last)

        let startIndex = max(0, newLineStartIndex)
        var endIndex = (toIndex) + (newLineEndIndex ?? 0)

        if newLineEndIndex == nil {
            endIndex = (text.utf16Length)
        }

        let range = startIndex...endIndex
        return range.nsRange
    }
}
