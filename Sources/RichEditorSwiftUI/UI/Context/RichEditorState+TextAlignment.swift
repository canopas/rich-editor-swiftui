//
//  RichEditorState+TextAlignment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/12/24.
//

import SwiftUI

extension RichEditorState {

    /// Get a binding for a certain TextAlignment style.
    public func textAlignmentBinding() -> Binding<RichTextAlignment> {
        Binding(
            get: { self.currentTextAlignment() },
            set: { self.setTextAlignmentStyle($0) }
        )
    }

    /// Check whether or not the context has a certain TextAlignment style.
    public func currentTextAlignment() -> RichTextAlignment {
        return textAlignment
    }

    /// Set whether or not the context has a certain TextAlignment style.
    public func setTextAlignmentStyle(
        _ alignment: RichTextAlignment
    ) {
        guard alignment != textAlignment else { return }
        updateStyle(style: alignment.getTextSpanStyle())
        setTextAlignmentInternal(alignment: alignment)
    }

    public func setTextAlignmentInternal(
        alignment: RichTextAlignment
    ) {
        guard alignment != textAlignment else { return }
        textAlignment = alignment
    }
}
