//
//  View+RichTextStyle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/11/24.
//

import SwiftUI

public extension View {

    /**
     Add a keyboard shortcut that toggles a certain style.

     This modifier only has effect on platforms that support
     keyboard shortcuts.
     */
    @ViewBuilder
    func keyboardShortcut(for style: RichTextStyle) -> some View {
        #if iOS || macOS || os(visionOS)
        switch style {
        case .bold: keyboardShortcut("b", modifiers: .command)
        case .italic: keyboardShortcut("i", modifiers: .command)
        case .strikethrough: self
        case .underline: keyboardShortcut("u", modifiers: .command)
        }
        #else
        self
        #endif
    }
}
