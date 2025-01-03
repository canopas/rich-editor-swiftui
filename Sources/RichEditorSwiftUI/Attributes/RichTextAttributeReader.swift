//
//  RichTextAttributeReader.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

/// This protocol extends ``RichTextReader`` with functionality
/// for reading rich text attributes for the current rich text.
///
/// The protocol is implemented by `NSAttributedString` as well
/// as other types in the library.
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}

extension RichTextAttributeReader {

    /// Get a rich text attribute at a certain range.
    public func richTextAttribute<Value>(
        _ attribute: RichTextAttribute,
        at range: NSRange
    ) -> Value? {
        richTextAttributes(at: range)[attribute] as? Value
    }

    /// Get all rich text attributes at a certain range.
    public func richTextAttributes(
        at range: NSRange
    ) -> RichTextAttributes {
        if richText.string.utf16Length == 0 { return [:] }
        let range = safeRange(for: range, isAttributeOperation: true)
        return richText.attributes(at: range.location, effectiveRange: nil)
    }
}

//  RichTextAttributeReader+Font
extension RichTextAttributeReader {

    /// Get the font at a certain range.
    public func richTextFont(at range: NSRange) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }

    /// Get the font size (in points) at a certain range.
    public func richTextFontSize(at range: NSRange) -> CGFloat? {
        richTextFont(at: range)?.pointSize
    }
}

//  RichTextAttributeReader+Style
extension RichTextAttributeReader {

    /// Get the text styles at a certain range.
    public func richTextStyles(at range: NSRange) -> [RichTextSpanStyle] {
        let attributes = richTextAttributes(at: range)
        let traits = richTextFont(at: range)?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underline) }
        return styles.map({ $0.richTextSpanStyle })
    }
}
