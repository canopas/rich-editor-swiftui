//
//  RichTextView+Setup.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    import SwiftUI

    extension RichTextView {

        func setupSharedBehavior(
            with text: NSAttributedString,
            _ format: RichTextDataFormat?
        ) {
            attributedString = .empty
            if let format, !imageConfigurationWasSet {
                imageConfiguration = standardImageConfiguration(for: format)
            }
            attributedString = text

            setContentCompressionResistancePriority(
                .defaultLow, for: .horizontal)
        }

        func setup(_ theme: RichTextView.Theme) {
            guard richText.string.isEmpty else { return }
            font = theme.font
            textColor = theme.fontColor
            backgroundColor = theme.backgroundColor
        }
    }
#endif
