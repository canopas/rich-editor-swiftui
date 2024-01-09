//
//  RichTextAttributeWriter+Style.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

public extension NSMutableAttributedString {
    
    /**
     Set a rich text style at a certain range.
     
     The function uses `safeRange(for:)` to handle incorrect
     ranges, which is not handled by the native functions.
     
     - Parameters:
     - style: The style to set.
     - newValue: The new value to set the attribute to.
     - range: The range to affect, by default the entire text.
     */
    func setRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool,
        at range: NSRange? = nil
    ) {
        let rangeValue = range ?? richTextRange
        let range = safeRange(for: rangeValue)
        let attributeValue = newValue ? 1 : 0
        if style == .underline { return setRichTextAttribute(.underlineStyle, to: attributeValue, at: range) }
        guard let font = richTextFont(at: range) else { return }
        let styles = richTextStyles(at: range)
        let shouldAdd = newValue && !styles.hasStyle(style)
        let shouldRemove = !newValue && styles.hasStyle(style)
        guard shouldAdd || shouldRemove else { return }
        let newFont: FontRepresentable? = FontRepresentable(
            descriptor: font.fontDescriptor.byTogglingStyle(style),
            size: byTogglingFontSizeFor(style: style, fontSize: font.pointSize, shouldAdd: shouldAdd))
        guard let newFont = newFont else { return }
        setRichTextFont(newFont, at: range)
    }
    
    func byTogglingFontSizeFor(style: TextSpanStyle, fontSize: CGFloat, shouldAdd: Bool) -> CGFloat {
        if shouldAdd {
            return fontSize * style.fontSizeMultiplier
        } else {
            return fontSize / style.fontSizeMultiplier
        }
    }
}
