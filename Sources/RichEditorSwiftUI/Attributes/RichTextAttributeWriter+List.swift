//
//  RichTextAttributeWriter+List.swift
//
//
//  Created by Divyesh Vekariya on 09/05/24.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextAttributeWriter {

    /**
     Set the text alignment at a certain range.

     Unlike some other attributes, this value applies to the
     entire paragraph, not just the selected range.
     */
    func setRichTextListStyle(
        _ listType: ListType,
        to newValue: Bool,
        at range: NSRange
    ) {
        setListStyle(listType, to: newValue, at: range)
    }
}

private extension RichTextAttributeWriter {

    func setListStyle(
        _ listType: ListType,
        to newValue: Bool,
        at range: NSRange
    ) {
        guard let string = mutableRichText else { return }
        let safeRange = safeRange(for: range)

        let searchRange = NSRange(location: max(0, (range.location - 1)), length: min(string.string.utf16Length, (range.length + 1)))
        var previousRang: NSRange? = nil

        var attributesWithRange: [Int: (range: NSRange, paragraphStyle: NSMutableParagraphStyle)] = [:]
        string.beginEditing()
        var previousStyle: NSMutableParagraphStyle? = nil
        string.enumerateAttribute(.paragraphStyle, in: searchRange) { (attribute, range, _) in

            if let style = attribute as? NSMutableParagraphStyle, !style.textLists.isEmpty {
                if newValue {
                    /// For add style
                    attributesWithRange[attributesWithRange.count] = (range: range, paragraphStyle: style)

                    if safeRange.location <= range.location && safeRange.upperBound >= range.upperBound {
                        string.removeAttribute(.paragraphStyle, range: range)
                    }

                    if let oldRange = previousRang, let previousStyle = previousStyle, previousStyle.textLists.count == listType.getIndent() {
                        let location = min(oldRange.location, range.location)
                        let length = max(oldRange.upperBound, range.upperBound) - location
                        let combinedRange = NSRange(location: location, length: length)

                        string.addAttribute(.paragraphStyle, value: previousStyle, range: combinedRange)
                        previousRang = combinedRange
                    } else {
                        let location = min(safeRange.location, range.location)
                        let length = max(safeRange.upperBound, range.upperBound) - location
                        let combinedRange = NSRange(location: location, length: length)

                        string.addAttribute(.paragraphStyle, value: style, range: combinedRange)
                        previousRang = combinedRange
                    }
                    previousStyle = style
                } else {
                    /// Fore Remove Style
                    if safeRange.closedRange.overlaps(range.closedRange) {
                        if style.textLists.count == listType.getIndent() {
                            string.removeAttribute(.paragraphStyle, range: safeRange)
                            previousRang = nil
                            previousStyle = nil
                        }
                    }
                }
            }
        }

        ///Add style if not already added
        if attributesWithRange.isEmpty {
            
            let paragraphStyle = NSMutableParagraphStyle()

            paragraphStyle.alignment = .left
            let listItem = TextList(markerFormat: listType.getMarkerFormat(), options: 0)

            if paragraphStyle.textLists.isEmpty && newValue {
                paragraphStyle.textLists.append(listItem)
            } else {
                paragraphStyle.textLists.removeAll()
            }

            if !paragraphStyle.textLists.isEmpty {
                string.addAttributes([.paragraphStyle: paragraphStyle], range: safeRange)
            } else {
                string.removeAttribute(.paragraphStyle, range: safeRange)
            }
        }

        string.fixAttributes(in: range)
        string.endEditing()
    }
}
