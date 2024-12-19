//
//  RTEL10n.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

/// This enum defines RichTextKit-specific, localized texts.
public enum RTEL10n: String, CaseIterable, Identifiable {

    case
        done,
        more,

        font,
        fontSize,
        fontSizeIncrease,
        fontSizeIncreaseDescription,
        fontSizeDecrease,
        fontSizeDecreaseDescription,

        setHeaderStyle,

        color,
        foregroundColor,
        backgroundColor,
        underlineColor,
        strikethroughColor,
        strokeColor,

        actionCopy,
        actionDismissKeyboard,
        actionPrint,
        actionRedoLatestChange,
        actionUndoLatestChange,

        fileFormatRtk,
        fileFormatPdf,
        fileFormatRtf,
        fileFormatTxt,
        fileFormatJson,

        indent,
        indentIncrease,
        indentIncreaseDescription,
        indentDecrease,
        indentDecreaseDescription,

        lineSpacing,
        lineSpacingIncrease,
        lineSpacingIncreaseDescription,
        lineSpacingDecrease,
        lineSpacingDecreaseDescription,

        menuExport,
        menuExportAs,
        menuFormat,
        menuPrint,
        menuSave,
        menuSaveAs,
        menuShare,
        menuShareAs,
        menuText,

        highlightedRange,
        highlightingStyle,

        pasteImage,
        pasteImages,
        pasteText,
        selectRange,

        setAttributedString,

        styleBold,
        styleItalic,
        styleStrikethrough,
        styleUnderlined,

        superscript,
        superscriptIncrease,
        superscriptIncreaseDescription,
        superscriptDecrease,
        superscriptDecreaseDescription,

        textAlignment,
        textAlignmentLeft,
        textAlignmentRight,
        textAlignmentCentered,
        textAlignmentJustified,

        headerDefault,
        header1,
        header2,
        header3,
        header4,
        header5,
        header6,

        link,

        ignoreIt
}

extension RTEL10n {

    public static func actionStepFontSize(
        _ points: Int
    ) -> RTEL10n {
        points < 0 ? .fontSizeDecreaseDescription : .fontSizeIncreaseDescription
    }

    public static func actionStepIndent(
        _ points: Double
    ) -> RTEL10n {
        points < 0 ? .indentDecreaseDescription : .indentIncreaseDescription
    }

    public static func actionStepLineSpacing(
        _ points: CGFloat
    ) -> RTEL10n {
        points < 0
            ? .lineSpacingDecreaseDescription : .lineSpacingIncreaseDescription
    }

    public static func actionStepSuperscript(
        _ steps: Int
    ) -> RTEL10n {
        steps < 0
            ? .superscriptDecreaseDescription : .superscriptIncreaseDescription
    }

    public static func menuIndent(_ points: Double) -> RTEL10n {
        points < 0 ? .indentDecrease : .indentIncrease
    }
}

extension RTEL10n {

    /// The item's unique identifier.
    public var id: String { rawValue }

    /// The item's localization key.
    public var key: String { rawValue }

    /// The item's localized text.
    public var text: String {
        rawValue
    }

    /// Get the localized text for a certain `Locale`.
    //    func text(for locale: Locale) -> String {
    //        guard let bundle = Bundle.module.bundle(for: locale) else { return "" }
    //        return NSLocalizedString(key, bundle: bundle, comment: "")
    //    }
}
