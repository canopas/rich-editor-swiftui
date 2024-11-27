//
//  NSAttributedString+Export.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

@MainActor
extension NSAttributedString {

    /// Make all text black to account for dark mode.
    func withBlackText() -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: self)
        let range = mutable.safeRange(for: NSRange(location: 0, length: mutable.length))
        mutable.setRichTextAttribute(.foregroundColor, to: ColorRepresentable.black, at: range)
        return mutable
    }
}
