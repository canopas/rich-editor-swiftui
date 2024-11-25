//
//  RichTextStyle+ToggleStack.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/11/24.
//

import SwiftUI

public extension RichTextStyle {

    /**
     This view can list ``RichTextStyle/Toggle``s for a list
     of ``RichTextStyle`` values, in a horizontal stack.

     Since this view uses multiple styles, it binds directly
     to a ``RichTextContext`` instead of individual values.
     */
    struct ToggleStack: View {

        /**
         Create a rich text style toggle button group.

         - Parameters:
           - context: The context to affect.
           - styles: The styles to list, by default ``RichTextStyle/all``.
           - spacing: The spacing to apply to stack items, by default `5`.
         */
        public init(
            context: RichEditorState,
            styles: [RichTextStyle] = .all,
            spacing: Double = 5
        ) {
            self._context = ObservedObject(wrappedValue: context)
            self.styles = styles
            self.spacing = spacing
        }

        private let styles: [RichTextStyle]
        private let spacing: Double

        @ObservedObject
        private var context: RichEditorState

        public var body: some View {
            HStack(spacing: spacing) {
                ForEach(styles) {
                    RichTextStyle.Toggle(
                        style: $0,
                        context: context,
                        fillVertically: true
                    )
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
