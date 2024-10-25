//
//  RichTextViewComponent+Colors.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import Foundation

public extension RichTextViewComponent {

    /// Get a certain color.
    func richTextColor(
        _ color: RichTextColor
    ) -> ColorRepresentable? {
        guard let attribute = color.attribute else { return nil }
        return richTextAttribute(attribute)
    }

    /// Get a certain color at a certain range.
    func richTextColor(
        _ color: RichTextColor,
        at range: NSRange
    ) -> ColorRepresentable? {
        guard let attribute = color.attribute else { return nil }
        return richTextAttribute(attribute, at: range)
    }

    /// Set a certain color.
    func setRichTextColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        if richTextColor(color) == val { return }
        guard let attribute = color.attribute else { return }
        setRichTextAttribute(attribute, to: val)
    }

    /// Set a certain colors at a certain range.
    func setRichTextColor(
        _ color: RichTextColor,
        to val: ColorRepresentable,
        at range: NSRange
    ) {
        guard let attribute = color.attribute else { return }
        if richTextColor(color, at: range) == val { return }
        setRichTextAttribute(attribute, to: val, at: range)
    }
}
