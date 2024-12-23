//
//  RichTextFontSizePickerStack.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 29/10/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
    import SwiftUI

    extension RichTextFont {

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
        public struct SizePickerStack: View {

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
                #if os(iOS) || os(visionOS)
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

    extension RichTextFont.SizePickerStack {

        fileprivate var macShortcutOverlay: some View {
            stack
                .opacity(0)
                .allowsHitTesting(false)
        }

        fileprivate var stack: some View {
            HStack(spacing: 2) {
                stepButton(-step)
                picker
                stepButton(step)
            }
        }

        fileprivate func stepButton(_ points: Int) -> some View {
            RichTextAction.Button(
                action: .stepFontSize(points: points),
                context: context,
                fillVertically: true
            )
        }

        fileprivate var picker: some View {
            RichTextFont.SizePicker(
                selection: $context.fontSize
            )
            .onChangeBackPort(of: context.fontSize) { newValue in
                context.updateStyle(style: .size(Int(context.fontSize)))
            }
        }

        fileprivate var stepper: some View {
            Stepper(
                "",
                onIncrement: increment,
                onDecrement: decrement
            )
        }

        fileprivate func decrement() {
            context.fontSize -= CGFloat(step)
        }

        fileprivate func increment() {
            context.fontSize += CGFloat(step)
        }
    }
#endif
