//
//  RichEditor.swift
//
//
//  Created by Divyesh Vekariya on 24/10/23.
//

import SwiftUI

public struct RichEditor: View {
    @ObservedObject var state: RichEditorState

    public init(state: ObservedObject<RichEditorState>) {
        self._state = state
    }

    public var body: some View {
        VStack(content: {
            EditorToolBarView(state: state)

            TextViewWrapper(state: _state,
                            attributesToApply:  $state.attributesToApply,
                            isScrollEnabled: true,
                            fontStyle: state.currentFont,
                            onTextViewEvent: state.onTextViewEvent(_:))
        })
    }
}
