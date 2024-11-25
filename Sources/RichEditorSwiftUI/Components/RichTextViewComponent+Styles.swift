//
//  RichTextViewComponent+Styles.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/10/24.
//

import Foundation

public extension RichTextViewComponent {

    /// Get all styles.
    var richTextStyles: [RichTextStyle] {
        let attributes = richTextAttributes
        let traits = richTextFont?.fontDescriptor.symbolicTraits
        var styles = traits?.enabledRichTextStyles ?? []
        if attributes.isStrikethrough { styles.append(.strikethrough) }
        if attributes.isUnderlined { styles.append(.underline) }
        return styles
    }

    /// Whether or not the current range has a certain style.
    func hasRichTextStyle(_ style: RichTextStyle) -> Bool {
        richTextStyles.contains(style)
    }

    /// Set a certain style.
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool
    ) {
        let value = newValue ? 1 : 0
        switch style {
            case .bold, .italic:
                let styles = richTextStyles
                guard styles.shouldAddOrRemove(style, newValue) else { return }
                guard let font = richTextFont else { return }
                guard let newFont = font.toggling(style) else { return }
                setRichTextFont(newFont)
            case .underline:
                setRichTextAttribute(.underlineStyle, to: value)
            case .strikethrough:
                setRichTextAttribute(.strikethroughStyle, to: value)
        }
    }

    /// Toggle a certain style.
    func toggleRichTextStyle(
        _ style: RichTextStyle
    ) {
        let hasStyle = hasRichTextStyle(style)
        setRichTextStyle(style, to: !hasStyle)
    }
}

