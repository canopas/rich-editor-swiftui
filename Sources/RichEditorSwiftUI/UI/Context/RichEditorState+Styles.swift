//
//  RichEditorState+Styles.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/10/24.
//

import SwiftUI

extension RichEditorState {

    /// Get a binding for a certain style.
    public func binding(for style: RichTextStyle) -> Binding<Bool> {
        Binding(
            get: { Bool(self.hasStyle(style)) },
            set: { [weak self] _ in self?.setStyle(style) }
        )
    }

    /// Check whether or not the context has a certain style.
    public func hasStyle(_ style: RichTextStyle) -> Bool {
        styles[style] == true
    }

    /// Set whether or not the context has a certain style.
    public func setStyle(
        _ style: RichTextStyle,
        to val: Bool
    ) {
        guard styles[style] != val else { return }
        actionPublisher.send(.setStyle(style, val))
        setStyleInternal(style, to: val)
    }

    /// Toggle a certain style for the context.
    public func toggleStyle(_ style: RichTextStyle) {
        setStyle(style, to: !hasStyle(style))
    }

    public func setStyle(_ style: RichTextStyle) {
        toggleStyle(style: style.richTextSpanStyle)
    }
}

extension RichEditorState {

    /// Set the value for a certain color, or remove it.
    func setStyleInternal(
        _ style: RichTextStyle,
        to val: Bool?
    ) {
        guard let val else {
            styles[style] = nil
            return
        }
        styles[style] = val
    }
}
