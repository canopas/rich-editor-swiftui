//
//  RichTextOtherMenu+Toggle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

import SwiftUI

#if os(iOS) || os(macOS) || os(visionOS)
  extension RichTextOtherMenu {

    /**
     This toggle can be used to toggle a ``RichTextOtherMenu``.

     This view renders a plain `Toggle`, which means you can
     use and configure with plain SwiftUI. The one exception
     is the tint color, which is set with a style.
     */
    public struct Toggle: View {

      /**
         Create a rich text style toggle toggle.

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
         Create a rich text style toggle.

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
        #if os(tvOS) || os(watchOS)
          toggle
        #else
          toggle.toggleStyle(.button)
        #endif
      }

      private var toggle: some View {
        SwiftUI.Toggle(isOn: value) {
          style.icon
            .frame(maxHeight: fillVertically ? .infinity : nil)
        }
        //            .keyboardShortcut(for: style)
        .accessibilityLabel(style.title)
      }
    }
  }

  extension RichTextOtherMenu.Toggle {

    fileprivate var isOn: Bool {
      value.wrappedValue
    }
  }
#endif
