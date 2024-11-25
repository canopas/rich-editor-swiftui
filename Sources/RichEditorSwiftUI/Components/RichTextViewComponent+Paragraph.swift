//
//  RichTextViewComponent+Paragraph.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 25/11/24.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the paragraph style.
    var richTextParagraphStyle: NSMutableParagraphStyle? {
        richTextAttribute(.paragraphStyle)
    }

    /// Set the paragraph style.
    ///
    /// > Todo: The function currently can't handle multiple
    /// selected paragraphs. If many paragraphs are selected,
    /// it will only affect the first one.
    func setRichTextParagraphStyle(_ style: NSParagraphStyle) {
        let range = lineRange(for: selectedRange)
        guard range.length > 0 else { return }
        #if os(watchOS)
        setRichTextAttribute(.paragraphStyle, to: style, at: range)
        #else
        textStorageWrapper?.addAttribute(.paragraphStyle, value: style, range: range)
        #endif
    }
}
