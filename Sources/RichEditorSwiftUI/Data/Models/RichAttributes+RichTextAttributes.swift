//
//  RichAttributes+RichTextAttributes.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 24/10/24.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

import SwiftUI

extension RichAttributes {
    func toAttributes(font: FontRepresentable? = nil) -> RichTextAttributes {
        var attributes: RichTextAttributes = [:]

        // Set the font size and handle headers
        var font = font ?? RichTextView.Theme.standard.font
        if let headerType = self.header?.getTextSpanStyle() {
            font = font
                .updateFontSize(
                    size: font.pointSize * headerType.fontSizeMultiplier
                )
        }

        if let size = size {
            font = font.updateFontSize(size: CGFloat(size))
        }

        if let fontName = self.font {
            font = font.updateFontName(with: fontName)
        }

        // Apply bold and italic styles
        if let isBold = bold, isBold {
            font = font.makeBold()
        }

        if let isItalic = italic, isItalic {
            font = font.makeItalic()
        }

        attributes[.font] = font

        // Apply underline
        if let isUnderline = underline, isUnderline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        // Apply strikethrough
        if let isStrike = strike, isStrike {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        if let color {
            attributes[.foregroundColor] = ColorRepresentable(Color(hex: color))
        }

        if let background {
            attributes[.backgroundColor] = ColorRepresentable(Color(hex: background))
        }

        if let align {
            let style = NSMutableParagraphStyle(from: nil, alignment: align)
            attributes[.paragraphStyle] = style
        }

        // Handle indent and paragraph styles
//        if let indentLevel = indent {
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.headIndent = CGFloat(indentLevel * 10)  // Adjust indentation as needed
//            attributes[.paragraphStyle] = paragraphStyle
//        }

        return attributes
    }
}
