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
            EditorToolBarView(appliedTools: state.activeStyles,
                              onToolSelect: state.onToolSelection(_:))
            
            TextViewWrapper(state: _state,
                            typingAttributes: $state.activeAttributes,
                            attributesToApply:  $state.attributesToApply,
                            isScrollEnabled: true,
                            fontStyle: state.curretFont,
                            onTextViewEvent: state.onTextViewEvent(_:))
        })
        .padding()
    }
}
