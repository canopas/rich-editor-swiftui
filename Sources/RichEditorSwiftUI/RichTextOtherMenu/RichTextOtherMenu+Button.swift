//
//  RichTextOtherMenu+Button.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS)
  extension RichTextOtherMenu {

    /**
     This button can be used to toggle a ``RichTextOtherMenu``.

     This view renders a plain `Button`, which means you can
     use and configure with plain SwiftUI.
     */
    public struct Button: View {

      /**
         Create a rich text style button.

         - Parameters:
         - style: The style to toggle.
         - value: The value to bind to.
         - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
         */
      public init(
        style: RichTextOtherMenu,
        value: Binding<Bool>,
        fillVertically: Bool = false
      ) {
        self.style = style
        self.value = value
        self.fillVertically = fillVertically
      }

      /**
         Create a rich text style button.

         - Parameters:
         - style: The style to toggle.
         - context: The context to affect.
         - fillVertically: Whether or not fill up vertical space in a non-greedy way, by default `false`.
         */
      public init(
        style: RichTextOtherMenu,
        context: RichEditorState,
        fillVertically: Bool = false
      ) {
        self.init(
          style: style,
          value: context.bindingForManu(for: style),
          fillVertically: fillVertically
        )
      }

      private let style: RichTextOtherMenu
      private let value: Binding<Bool>
      private let fillVertically: Bool

      public var body: some View {
        SwiftUI.Button(action: toggle) {
          style.label
            .labelStyle(.iconOnly)
            .frame(maxHeight: fillVertically ? .infinity : nil)
            .contentShape(Rectangle())
        }
        .tint(.accentColor, if: isOn)
        .foreground(.accentColor, if: isOn)
        //            .keyboardShortcut(for: style)
        .accessibilityLabel(style.title)
      }
    }
  }

  extension RichTextOtherMenu.Button {

    fileprivate var isOn: Bool {
      value.wrappedValue
    }

    fileprivate func toggle() {
      value.wrappedValue.toggle()
    }
  }
#endif
