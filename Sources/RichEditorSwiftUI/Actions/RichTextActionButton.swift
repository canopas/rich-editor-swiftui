//
//  RichTextActionButton.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

import SwiftUI

public extension RichTextAction {

    /**
     This button can be used to trigger a ``RichTextAction``.

     This renders a plain `Button`, which means that you can
     use and configure it as a normal button.
     */
    struct Button: View {
        /**
         Create a rich text action button.

         - Parameters:
         - action: The action to trigger.
         - context: The context to affect.
         - fillVertically: WhetherP or not fill up vertical space, by default `false`.
         */
        public init(
            action: RichTextAction,
            context: RichEditorState,
            fillVertically: Bool = false
        ) {
            self.action = action
            self._context = ObservedObject(wrappedValue: context)
            self.fillVertically = fillVertically
        }

        private let action: RichTextAction
        private let fillVertically: Bool

        @ObservedObject
        private var context: RichEditorState

        public var body: some View {
            SwiftUI.Button(action: triggerAction) {
                action.label
                    .labelStyle(.iconOnly)
                    .frame(maxHeight: fillVertically ? .infinity : nil)
                    .contentShape(Rectangle())
            }
            .keyboardShortcut(for: action)
            .disabled(!context.canHandle(action))
        }
    }
}

private extension RichTextAction.Button {

    func triggerAction() {
        context.handle(action)
    }
}
