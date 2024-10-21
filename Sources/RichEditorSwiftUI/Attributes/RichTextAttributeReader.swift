//
//  RichTextAttributeReader.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

/**
 This protocol extends ``RichTextReader`` with functionality
 for reading rich text attributes for the current rich text.
 
 The protocol is implemented by `NSAttributedString` as well
 as other types in the library.
 */
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}

public extension RichTextAttributeReader {
    
    /// Get a rich text attribute at a certain range.
    func richTextAttribute<Value>(
        _ attribute: RichTextAttribute,
        at range: NSRange
    ) -> Value? {
        richTextAttributes(at: range)[attribute] as? Value
    }
    
    /// Get all rich text attributes at a certain range.
    func richTextAttributes(
        at range: NSRange
    ) -> RichTextAttributes {
        if richText.string.utf16Length == 0 { return [:] }
        let range = safeRange(for: range, isAttributeOperation: true)
        return richText.attributes(at: range.location, effectiveRange: nil)
    }
}

//  RichTextAttributeReader+Font
public extension RichTextAttributeReader {
    
    /// Get the font at a certain range.
    func richTextFont(at range: NSRange) -> FontRepresentable? {
        richTextAttribute(.font, at: range)
    }
    
    /// Get the font size (in points) at a certain range.
    func richTextFontSize(at range: NSRange) -> CGFloat? {
        richTextFont(at: range)?.pointSize
    }
}

//  RichTextAttributeReader+Style
public extension RichTextAttributeReader {
    
    /// Get the text styles at a certain range.
    func richTextStyles(at range: NSRange) -> [RichTextStyle] {
        let attributes = richTextAttributes(at: range)
        let traits = richTextFont(at: range)?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underline) }
        return styles
    }
}
