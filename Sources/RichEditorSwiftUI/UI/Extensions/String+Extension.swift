//
//  String+Extension.swift
//
//
//  Created by Divyesh Vekariya on 18/10/23.
//

import SwiftUI

extension String {
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }

    func substring(from range: NSRange) -> String {
        let from = String.Index(utf16Offset: range.lowerBound, in: self)
        let to = String.Index(utf16Offset: range.upperBound, in: self)
        let utf16Range = from...to
        return String(self[utf16Range])
    }
}

internal struct NSFontTraitMask: OptionSet {
    internal let rawValue: Int
    internal static let boldFontMask = NSFontTraitMask(rawValue: 1 << 0)
    internal static let unboldFontMask = NSFontTraitMask(rawValue: 1 << 1)
    internal static let italicFontMask = NSFontTraitMask(rawValue: 1 << 2)
    internal static let unitalicFontMask = NSFontTraitMask(rawValue: 1 << 3)
    internal static let all: NSFontTraitMask = [.boldFontMask, .unboldFontMask, .italicFontMask, .unitalicFontMask]
    internal init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension NSMutableAttributedString {
    internal func applyFontTraits(_ traitMask: NSFontTraitMask, range: NSRange) {
        enumerateAttribute(.font, in: range, options: [.longestEffectiveRangeNotRequired]) { (attr, attrRange, stop) in
            guard let font = attr as? FontRepresentable else { return }
            let descriptor = font.fontDescriptor
            var symbolicTraits = descriptor.symbolicTraits
            if traitMask.contains(.boldFontMask) {
                symbolicTraits.insert(.traitBold)
            }
            if symbolicTraits.contains(.traitBold) && traitMask.contains(.unboldFontMask) {
                symbolicTraits.remove(.traitBold)
            }
            if traitMask.contains(.italicFontMask) {
                symbolicTraits.insert(.traitItalic)
            }
            if symbolicTraits.contains(.traitItalic) && traitMask.contains(.unitalicFontMask) {
                symbolicTraits.remove(.traitItalic)
            }
            guard let newDescriptor = descriptor.withSymbolicTraits(symbolicTraits) else { return }
            let newFont = FontRepresentable(descriptor: newDescriptor, size: font.pointSize)
            self.addAttribute(.font, value: newFont, range: attrRange)
        }
    }
}


/**
 This extension makes it possible to fetch characters from a
 string, as discussed here:

 https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
 */
public extension StringProtocol {

    func character(at index: Int) -> String.Element? {
        if index < 0 { return nil }
        guard count > index else { return nil }
        return self[index]
    }

    func character(at index: UInt) -> String.Element? {
        character(at: Int(index))
    }

    subscript(_ offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(_ range: Range<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }

    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }

    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        prefix(range.upperBound.advanced(by: 1))
    }

    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        prefix(range.upperBound)
    }

    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        suffix(Swift.max(0, count-range.lowerBound))
    }
}

private extension LosslessStringConvertible {

    var string: String { .init(self) }
}

private extension BidirectionalCollection {

    subscript(safe offset: Int) -> Element? {
        if isEmpty { return nil }
        guard let index = index(
            startIndex,
            offsetBy: offset,
            limitedBy: index(before: endIndex))
        else { return nil }
        return self[index]
    }
}


internal extension String {
    /**
     This will provide length of string with UTF16 character count
     */
    var utf16Length: Int {
        return self.utf16.count
    }
}
