//
//  RichTextView+Setup.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

extension RichTextView {

    func setupSharedBehavior() {
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func setup(_ theme: RichTextView.Theme, setupFont: Bool = false) {
        if setupFont {
            font = theme.font
        }

        textColor = theme.fontColor
        backgroundColor = theme.backgroundColor
    }
}
#endif
