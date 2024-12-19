//
//  RichTextContext+Color.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

extension RichEditorState {

    /// Get a binding for a certain color.
    public func binding(for color: RichTextColor) -> Binding<Color> {
        Binding(
            get: { Color(self.color(for: color) ?? .clear) },
            set: { self.updateStyleFor(color, to: .init($0)) }
        )
    }

    /// Get the value for a certain color.
    public func color(for color: RichTextColor) -> ColorRepresentable? {
        colors[color]
    }

    /// Set the value for a certain color.
    public func setColor(
        _ color: RichTextColor,
        to val: ColorRepresentable
    ) {
        guard self.color(for: color) != val else { return }
        actionPublisher.send(.setColor(color, val))
        setColorInternal(color, to: val)
    }

    public func updateStyleFor(
        _ color: RichTextColor, to val: ColorRepresentable
    ) {
        let value = Color(val)
        switch color {
        case .foreground:
            updateStyle(style: .color(value))
        case .background:
            updateStyle(style: .background(value))
        case .strikethrough:
            return
        case .stroke:
            return
        case .underline:
            return
        }
    }
}

extension RichEditorState {

    /// Set the value for a certain color, or remove it.
    func setColorInternal(
        _ color: RichTextColor,
        to val: ColorRepresentable?
    ) {
        guard let val else {
            colors[color] = nil
            return
        }
        colors[color] = val
    }
}
