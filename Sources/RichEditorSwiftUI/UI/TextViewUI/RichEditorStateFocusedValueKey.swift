//
//  RichEditorStateFocusedValueKey.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 25/11/24.
//

import SwiftUI

public extension RichEditorState {

    /// This key can be used to keep track of a context in a
    /// multi-windowed app.
    struct FocusedValueKey: SwiftUI.FocusedValueKey {

        public typealias Value = RichEditorState
    }
}

public extension FocusedValues {

    /// This value can be used to keep track of a context in
    /// a multi-windowed app.
    ///
    /// You can bind a context to a view with `focusedValue`:
    ///
    /// ```swift
    /// RichTextEditor(...)
    ///     .focusedValue(\.richTextContext, richTextContext)
    /// ```
    ///
    /// You can then access the context as a `@FocusedValue`:
    ///
    /// ```swift
    /// @FocusedValue(\.richEditorState)
    /// var richEditorState: RichEditorState?
    /// ```
    var richEditorState: RichEditorState.FocusedValueKey.Value? {
        get { self[RichEditorState.FocusedValueKey.self] }
        set { self[RichEditorState.FocusedValueKey.self] = newValue }
    }
}
