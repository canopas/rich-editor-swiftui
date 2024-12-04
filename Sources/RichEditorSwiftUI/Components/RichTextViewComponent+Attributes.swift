//
//  RichTextViewComponent+Attributes.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

public extension RichTextViewComponent {

    /// Get all attributes.
    var richTextAttributes: RichTextAttributes {
        if hasSelectedRange {
            return richTextAttributes(at: selectedRange)
        }

#if macOS
        let range = NSRange(location: selectedRange.location - 1, length: 1)
        let safeRange = safeRange(for: range)
        return richTextAttributes(at: safeRange)
#else
        return typingAttributes
#endif
    }

    /// Get a certain attribute.
    func richTextAttribute<Value>(
        _ attribute: RichTextAttribute
    ) -> Value? {
        richTextAttributes[attribute] as? Value
    }

    /// Set a certain attribute.
    func setRichTextAttribute(
        _ attribute: RichTextAttribute,
        to value: Any
    ) {
        if hasSelectedRange {
            setRichTextAttribute(attribute, to: value, at: selectedRange)
        } else {
            typingAttributes[attribute] = value
        }
    }

    /// Set certain attributes.
    func setRichTextAttributes(
        _ attributes: RichTextAttributes
    ) {
        attributes.forEach { attribute, value in
            setRichTextAttribute(attribute, to: value)
        }
    }

    func setNewRichTextAttributes(
        _ attributes: RichTextAttributes
    ) {
        typingAttributes = attributes
    }
}

