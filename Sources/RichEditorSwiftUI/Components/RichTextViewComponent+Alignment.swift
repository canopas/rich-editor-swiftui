//
//  RichTextViewComponent+Alignment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 25/11/24.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    /// Get the text alignment.
    var richTextAlignment: RichTextAlignment? {
        guard let style = richTextParagraphStyle else { return nil }
        return RichTextAlignment(style.alignment)
    }

    /// Set the text alignment.
    func setRichTextAlignment(_ alignment: RichTextAlignment) {
        if richTextAlignment == alignment { return }
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            alignment: alignment
        )
        setRichTextParagraphStyle(style)
    }
}
