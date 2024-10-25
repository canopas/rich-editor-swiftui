//
//  RichTextPresenter.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

/**
 This protocol can be implemented any types that can present
 a rich text and provide a ``selectedRange``.

 This protocol is implemented by ``RichTextEditor`` since it
 can both present and select text. It is also implemented by
 the platform-specific ``RichTextView`` components.
 */
public protocol RichTextPresenter: RichTextReader {

    /// Get the currently selected range.
    var selectedRange: NSRange { get }
}

public extension RichTextPresenter {

    /// Whether or not the presenter has a selected range.
    var hasSelectedRange: Bool {
        selectedRange.length > 0
    }

    /// Whether or not the rich text contains trimmed text.
    var hasTrimmedText: Bool {
        let string = richText.string
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        return !trimmed.isEmpty
    }

    /// Get the range after the input cursor.
    var rangeAfterInputCursor: NSRange {
        let location = selectedRange.location
        let length = richText.length - location
        return NSRange(location: location, length: length)
    }

    /// Get the range before the input cursor.
    var rangeBeforeInputCursor: NSRange {
        let location = selectedRange.location
        return NSRange(location: 0, length: location)
    }

    /// Get the rich text after the input cursor.
    var richTextAfterInputCursor: NSAttributedString {
        richText(at: rangeAfterInputCursor)
    }

    /// Get the rich text before the input cursor.
    var richTextBeforeInputCursor: NSAttributedString {
        richText(at: rangeBeforeInputCursor)
    }
}

