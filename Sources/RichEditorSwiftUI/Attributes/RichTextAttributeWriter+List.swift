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
        _ alignment: ListType,
        to newValue: Bool,
        at range: NSRange
    ) {
        let text = richText.string

        // Text view has selected text
        if range.length > 0 {
            return setListStyle(alignment, to: newValue, at: range)
        }

        // The cursor is at the beginning of the text
        if range.location == 0 {
            return setListStyle(alignment, to: newValue, atIndex: 0)
        }

        // The cursor is immediately after a newline
        if let char = text.character(at: range.location - 1), char.isNewLineSeparator {
            return setListStyle(alignment, to: newValue, atIndex: range.location)
        }

        // The cursor is immediately before a newline
        if let char = text.character(at: range.location), char.isNewLineSeparator {
            let location = UInt(range.location)
            let index = text.findIndexOfCurrentParagraph(from: location)
            return setListStyle(alignment, to: newValue, atIndex: index)
        }

        // The cursor is somewhere within a paragraph
        let location = UInt(range.location)
        let index = text.findIndexOfCurrentParagraph(from: location)
        return setListStyle(alignment, to: newValue, atIndex: index)
    }
}

private extension RichTextAttributeWriter {

    func setListStyle(
        _ listType: ListType,
        to newValue: Bool,
        at range: NSRange
    ) {
        let text = richText.string
        let length = range.length
        let location = range.location
        let ulocation = UInt(location)
        var index = text.findIndexOfCurrentParagraph(from: ulocation)
        setListStyle(listType, to: newValue, atIndex: index)
        repeat {
            let newIndex = text.findIndexOfNextParagraph(from: index)
            if newIndex > index && newIndex < (location + length) {
                setListStyle(listType, to: newValue, atIndex: newIndex)
            } else {
                break
            }
            index = newIndex
        } while true
    }

    func setListStyle(
        _ listType: ListType,
        to newValue: Bool,
        atIndex index: Int
    ) {
        guard let text = mutableRichText else { return }
        let range = NSRange(location: index, length: 1)
        let safeRange = safeRange(for: range, isAttributeOperation: true)
        var attributes = text.attributes(at: safeRange.location, effectiveRange: nil)
        let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.alignment = .left
        let listItem = NSTextList(markerFormat: listType.getMarkerFormat(), options: 0)

        if !style.textLists.isEmpty && style.textLists.count >= listType.getIndent() && newValue {
            style.textLists[listType.getIndent()] = listItem
        } else if style.textLists.isEmpty && newValue {
            style.textLists.append(listItem)
        } else {
            style.textLists.removeAll()
        }

        attributes[.paragraphStyle] = style
        text.beginEditing()
        text.setAttributes(attributes, range: safeRange)
        text.fixAttributes(in: safeRange)
        text.endEditing()
    }

    func setListStyle(
        _ listType: ListType,
        to newValue: Bool,
        atIndex index: UInt
    ) {
        let index = Int(index)
        setListStyle(listType, to: newValue, atIndex: index)
    }
}
