//
//  RichEditorState+TextAlignment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/12/24.
//

import SwiftUI

public extension RichEditorState {

    /// Get a binding for a certain TextAlignment style.
    func textAlignmentBinding() -> Binding<RichTextAlignment> {
        Binding(
            get: { self.currentTextAlignment() },
            set: { self.setTextAlignmentStyle($0) }
        )
    }

    /// Check whether or not the context has a certain TextAlignment style.
    func currentTextAlignment() -> RichTextAlignment {
        return textAlignment
    }

    /// Set whether or not the context has a certain TextAlignment style.
    func setTextAlignmentStyle(
        _ alignment: RichTextAlignment
    ) {
        guard alignment != textAlignment else { return }
        updateStyle(style: alignment.getTextSpanStyle())
        setTextAlignmentInternal(alignment: alignment)
    }

    func setTextAlignmentInternal(
        alignment: RichTextAlignment
    ) {
        guard alignment != textAlignment else { return }
        textAlignment = alignment
    }
}

