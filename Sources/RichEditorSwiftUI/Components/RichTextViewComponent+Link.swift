//
//  RichTextViewComponent+Link.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/12/24.
//

import Foundation

extension RichTextViewComponent {
    /// Get the paragraph style.
    public var richTextLink: String? {
        richTextAttribute(.link)
    }

    /// Get a certain link.
    public func richTextLink(
        _ style: RichTextSpanStyle
    ) -> String? {
        return richTextAttribute(style.attributedStringKey)
    }

    /// Get a certain link at a certain range.
    public func richTextLink(
        _ style: RichTextSpanStyle,
        at range: NSRange
    ) -> String? {
        return richTextAttribute(style.attributedStringKey, at: range)
    }

    /// Set a certain link.
    public func setRichTextLink(
        _ style: RichTextSpanStyle
    ) {
        guard let val = style.getRichAttribute()?.link,
            richTextLink(style) != val
        else { return }
        setRichTextAttribute(style.attributedStringKey, to: val)

    }

    /// Set a certain link at a certain range.
    public func setRichTextLink(
        _ style: RichTextSpanStyle,
        at range: NSRange
    ) {
        let val = style.getRichAttribute()?.link
        guard let val = val, richTextLink(style, at: range) != val else {
            return
        }
        setRichTextAttribute(style.attributedStringKey, to: val, at: range)
    }

    public func removeRichTextLink(_ style: RichTextSpanStyle) {
        removeRichTextAttribute(style.attributedStringKey)
    }

    public func removeRichTextLink(
        _ style: RichTextSpanStyle, at range: NSRange
    ) {
        removeRichTextAttribute(style.attributedStringKey, at: range)
    }
}
