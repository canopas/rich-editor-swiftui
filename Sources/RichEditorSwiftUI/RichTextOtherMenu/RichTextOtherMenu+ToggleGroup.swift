//
//  RichTextOtherMenu+ToggleGroup.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/12/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
  import SwiftUI

  extension RichTextOtherMenu {

    /**
     This view can list ``RichTextOtherMenu/Toggle``s for a list
     of ``RichTextOtherMenu`` values, in a bordered button group.

     Since this view uses multiple styles, it binds directly
     to a ``RichTextContext`` instead of individual values.

     > Important: Since the `ControlGroup` doesn't highlight
     buttons in iOS, we use a `ToggleStack` for iOS.
     */
    public struct ToggleGroup: View {

      /**
         Create a rich text style toggle button group.

         - Parameters:
         - context: The context to affect.
         - styles: The styles to list, by default ``RichTextOtherMenu/all``.
         - greedy: Whether or not the group is horizontally greedy, by default `true`.
         */
      public init(
        context: RichEditorState,
        styles: [RichTextOtherMenu] = .all,
        greedy: Bool = true
      ) {
        self._context = ObservedObject(wrappedValue: context)
        self.isGreedy = greedy
        self.styles = styles
      }

      private let styles: [RichTextOtherMenu]
      private let isGreedy: Bool

      private var groupWidth: CGFloat? {
        if isGreedy { return nil }
        let count = Double(styles.count)
        #if os(macOS)
          return 30 * count
        #else
          return 50 * count
        #endif
      }

      @ObservedObject
      private var context: RichEditorState

      public var body: some View {
        #if os(macOS)
          ControlGroup {
            ForEach(styles) {
              RichTextOtherMenu.Toggle(
                style: $0,
                context: context,
                fillVertically: true
              )
            }
          }
          .frame(width: groupWidth)
        #else
          RichTextOtherMenu.ToggleStack(
            context: context,
            styles: styles
          )
        #endif
      }
    }
  }
#endif
