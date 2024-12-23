//
//  Image+RichText.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

extension Image {

    public static let richTextCopy = symbol("doc.on.clipboard")
    public static let richTextDismissKeyboard = symbol(
        "keyboard.chevron.compact.down")
    public static let richTextEdit = symbol("square.and.pencil")
    public static let richTextExport = symbol("square.and.arrow.up.on.square")
    public static let richTextPrint = symbol("printer")
    public static let richTextRedo = symbol("arrow.uturn.forward")
    public static let richTextShare = symbol("square.and.arrow.up")
    public static let richTextUndo = symbol("arrow.uturn.backward")

    public static let richTextAlignmentCenter = symbol("text.aligncenter")
    public static let richTextAlignmentJustified = symbol("text.justify")
    public static let richTextAlignmentLeft = symbol("text.alignleft")
    public static let richTextAlignmentRight = symbol("text.alignright")

    public static let richTextColorBackground = symbol("highlighter")
    public static let richTextColorForeground = symbol("character")
    public static let richTextColorReset = symbol("circle.slash")
    public static let richTextColorStroke = symbol("a.square")
    public static let richTextColorStrikethrough = symbol("strikethrough")
    public static let richTextColorUnderline = symbol("underline")
    public static let richTextColorUndefined = symbol("questionmark.app")

    public static let richTextHeaderDefault = symbol("textformat")
    public static let richTextHeader1 = symbol("textformat")
    public static let richTextHeader2 = symbol("textformat")
    public static let richTextHeader3 = symbol("textformat")
    public static let richTextHeader4 = symbol("textformat")
    public static let richTextHeader5 = symbol("textformat")
    public static let richTextHeader6 = symbol("textformat")

    public static let richTextDocument = symbol("doc.text")
    public static let richTextDocuments = symbol("doc.on.doc")

    public static let richTextFont = symbol("textformat")
    public static let richTextFontSizeDecrease = symbol("minus")
    public static let richTextFontSizeIncrease = symbol("plus")

    public static let richTextFormat = symbol("textformat")
    public static let richTextFormatBrush = symbol("paintbrush")

    public static let richTextIndentDecrease = symbol("decrease.indent")
    public static let richTextIndentIncrease = symbol("increase.indent")

    public static let richTextLineSpacing = symbol(
        "arrow.up.and.down.text.horizontal")
    public static let richTextLineSpacingDecrease = symbol("minus")
    public static let richTextLineSpacingIncrease = symbol("plus")

    public static let richTextSelection = symbol("123.rectangle.fill")

    public static let richTextStyleBold = symbol("bold")
    public static let richTextStyleItalic = symbol("italic")
    public static let richTextStyleStrikethrough = symbol("strikethrough")
    public static let richTextStyleUnderline = symbol("underline")

    public static let richTextSuperscriptDecrease = symbol(
        "textformat.subscript")
    public static let richTextSuperscriptIncrease = symbol(
        "textformat.superscript")
    public static let richTextLink = symbol("link")
    public static let richTextIgnoreIt = symbol("")
}

extension Image {

    public static func richTextStepFontSize(
        _ points: Int
    ) -> Image {
        points < 0 ? .richTextFontSizeDecrease : .richTextFontSizeIncrease
    }

    public static func richTextStepIndent(
        _ points: Double
    ) -> Image {
        points < 0 ? .richTextIndentDecrease : .richTextIndentIncrease
    }

    public static func richTextStepLineSpacing(
        _ points: Double
    ) -> Image {
        points < 0 ? .richTextLineSpacingDecrease : .richTextLineSpacingIncrease
    }

    public static func richTextStepSuperscript(
        _ steps: Int
    ) -> Image {
        steps < 0 ? .richTextSuperscriptDecrease : .richTextSuperscriptIncrease
    }
}

extension Image {

    static func symbol(_ name: String) -> Image {
        .init(systemName: name)
    }
}
