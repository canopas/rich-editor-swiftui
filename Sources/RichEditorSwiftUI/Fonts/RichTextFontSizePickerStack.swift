//
//  RichTextFontSizePickerStack.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFont {

    /**
     This view uses a ``RichTextFont/SizePicker`` and button
     steppers to increment and a decrement the font size.

     You can configure this picker by applying a config view
     modifier to your view hierarchy:

     ```swift
     VStack {
     RichTextFont.SizePickerStack(...)
     ...
     }
     .richTextFontSizePickerConfig(...)
     ```
     */
    struct SizePickerStack: View {

        /**
         Create a rich text font size picker stack.

         - Parameters:
         - context: The context to affect.
         */
        public init(
            context: RichEditorState
        ) {
            self._context = ObservedObject(wrappedValue: context)
        }

        private let step = 1

        @ObservedObject
        private var context: RichEditorState

        public var body: some View {
#if iOS || os(visionOS)
            stack
                .fixedSize(horizontal: false, vertical: true)
#else
            HStack(spacing: 3) {
                picker
                stepper
            }
            .overlay(macShortcutOverlay)
#endif
        }
    }
}

private extension RichTextFont.SizePickerStack {

    var macShortcutOverlay: some View {
        stack
            .opacity(0)
            .allowsHitTesting(false)
    }

    var stack: some View {
        HStack(spacing: 2) {
            stepButton(-step)
            picker
            stepButton(step)
        }
    }

    func stepButton(_ points: Int) -> some View {
        RichTextAction.Button(
            action: .stepFontSize(points: points),
            context: context,
            fillVertically: true
        )
    }

    var picker: some View {
        RichTextFont.SizePicker(
            selection: $context.fontSize
        )
        .onChangeBackPort(of: context.fontSize) { newValue in
            context.updateStyle(style: .size(Int(context.fontSize)))
        }
    }

    var stepper: some View {
        Stepper(
            "",
            onIncrement: increment,
            onDecrement: decrement
        )
    }

    func decrement() {
        context.fontSize -= CGFloat(step)
    }

    func increment() {
        context.fontSize += CGFloat(step)
    }
}
#endif
