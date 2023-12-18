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

    @State var id = UUID().uuidString
    
    public var body: some View {
        ScrollView {
            VStack(content: {
                EditorToolBarView(appliedTools: state.currentStyles, onToolSelect: state.onToolSelection(_:))
                
                TextViewWrapper(text: $state.editableText,
                                typingAttributes: $state.activeAttributes,
                                isScrollEnabled: false,
                                onTextViewEvent: state.onTextViewEvent(_:))
                .frame(minHeight: 300)
            })
            .padding()
        }
    }
}
