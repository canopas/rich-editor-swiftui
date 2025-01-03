//
//  File.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS)

  extension RichTextOtherMenu {

    /**
     This view can list ``RichTextOtherMenu/Toggle``s for a list
     of ``RichTextOtherMenu`` values, in a horizontal stack.

     Since this view uses multiple styles, it binds directly
     to a ``RichTextContext`` instead of individual values.
     */
    public struct ToggleStack: View {

      /**
         Create a rich text style toggle button group.

         - Parameters:
         - context: The context to affect.
         - styles: The styles to list, by default ``RichTextOtherMenu/all``.
         - spacing: The spacing to apply to stack items, by default `5`.
         */
      public init(
        context: RichEditorState,
        styles: [RichTextOtherMenu] = .all,
        spacing: Double = 5
      ) {
        self._context = ObservedObject(wrappedValue: context)
        self.styles = styles
        self.spacing = spacing
      }

      private let styles: [RichTextOtherMenu]
      private let spacing: Double

      @ObservedObject
      private var context: RichEditorState

      public var body: some View {
        HStack(spacing: spacing) {
          ForEach(styles) {
            RichTextOtherMenu.Toggle(
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
#endif
