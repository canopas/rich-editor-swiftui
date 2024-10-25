//
//  RichTextAction.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI
import Combine

/**
 This enum defines rich text actions that can be executed on
 a rich text editor.

 This type also serves as a type namespace for other related
 types and views, like ``RichTextAction/Button``.
 */
public enum RichTextAction: Identifiable, Equatable {

    /// Copy the currently selected text, if any.
    case copy

    /// Dismiss any presented software keyboard.
    case dismissKeyboard

    /// Paste a single image.
//    case pasteImage(RichTextInsertion<ImageRepresentable>)
//
//    /// Paste multiple images.
//    case pasteImages(RichTextInsertion<[ImageRepresentable]>)
//
//    /// Paste plain text.
//    case pasteText(RichTextInsertion<String>)

    /// A print command.
    case print

    /// Redo the latest undone change.
    case redoLatestChange

    /// Select a range.
    case selectRange(NSRange)

    /// Set the text alignment.
    case setAlignment(_ alignment: RichTextAlignment)

    /// Set the entire attributed string.
    case setAttributedString(NSAttributedString)

    // Change background color
    case setColor(RichTextColor, ColorRepresentable)

    // Highlighted renge
    case setHighlightedRange(NSRange?)

    // Change highlighting style
    case setHighlightingStyle(RichTextHighlightingStyle)

    /// Set a certain ``RichTextStyle``.
    case setStyle(RichTextStyle, Bool)

    /// Step the font size.
    case stepFontSize(points: Int)

    /// Step the indent level.
    case stepIndent(points: CGFloat)

    /// Step the line spacing.
    case stepLineSpacing(points: CGFloat)

    /// Step the superscript level.
    case stepSuperscript(steps: Int)

    /// Toggle a certain style.
    case toggleStyle(_ style: RichTextStyle)

    /// Undo the latest change.
    case undoLatestChange

    /// Set HeaderStyle.
    case setHeaderStyle(_ style: RichTextStyle, range: NSRange)
}

public extension RichTextAction {

    typealias Publisher = PassthroughSubject<Self, Never>

    /// The action's unique identifier.
    var id: String { UUID().uuidString }

    /// The action's standard icon.

}

// MARK: - Aliases

public extension RichTextAction {

    /// A name alias for `.redoLatestChange`.
    static var redo: RichTextAction { .redoLatestChange }

    /// A name alias for `.undoLatestChange`.
    static var undo: RichTextAction { .undoLatestChange }
}

public extension CGFloat {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: CGFloat = 30.0
}

public extension UInt {

    /// The default rich text indent step size.
    static var defaultRichTextIntentStepSize: UInt = 30
}

