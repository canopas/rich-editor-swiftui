//
//  RichEditorState+Styles.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/10/24.
//

import SwiftUI

public extension RichEditorState {

    /// Get a binding for a certain style.
    func binding(for style: RichTextStyle) -> Binding<Bool> {
        Binding(
            get: { Bool(self.hasStyle(style)) },
            set: { [weak self]_ in self?.setStyle(style) }
        )
    }

    /// Check whether or not the context has a certain style.
    func hasStyle(_ style: RichTextStyle) -> Bool {
        styles[style] == true
    }

    /// Set whether or not the context has a certain style.
    func setStyle(
        _ style: RichTextStyle,
        to val: Bool
    ) {
        guard styles[style] != val else { return }
        actionPublisher.send(.setStyle(style, val))
        setStyleInternal(style, to: val)
    }

    /// Toggle a certain style for the context.
    func toggleStyle(_ style: RichTextStyle) {
        setStyle(style, to: !hasStyle(style))
    }

    func setStyle(_ style: RichTextStyle) {
        toggleStyle(style: style.richTextSpanStyle)
    }
}

extension RichEditorState {

    /// Set the value for a certain color, or remove it.
    func setStyleInternal(
        _ style: RichTextStyle,
        to val: Bool?
    ) {
        guard let val else { return styles[style] = nil }
        styles[style] = val
    }
}

